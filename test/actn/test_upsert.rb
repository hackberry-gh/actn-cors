require 'minitest_helper'
require 'goliath/test_helper'
require 'apis/cors/upsert'
require 'actn/api/client'
require 'actn/db'

module Actn
  module Api
    class TestUpsert < MiniTest::Test
      
      include Goliath::TestHelper

      def setup
    
        mdata = Oj.dump({ name: "Supporter", schema: { 
          type: 'object',
          properties: {
            first_name: { type: 'string' }
          },
          required: ['first_name']
        } 
        })
        DB.exec_func(:upsert, 'core', 'models', mdata)

        10.times{ |i| DB::Set['supporters'].upsert({path: "/supporters", first_name: "supporter_#{random_str}"}) }
        
        @uuid =  Oj.load(DB::Set['supporters'].query({select: 'uuid', limit: 1}))[0]['uuid']
    
        @api_options = { :verbose => true, :log_stdout => true, config: "#{Actn::Api.root}/config/core.rb" }
        @err = Proc.new { assert false, "API request failed" }
    
        @client = Client.create({domain: "localhost:9900"})
        @headr = { 'X_APIKEY' => @client.credentials['apikey'] }
        @headrw = { 'X_APIKEY' => @client.credentials['apikey'], 'X_SECRET' => @client.credentials['secret'] }
      end
  
      def teardown
        DB.exec_func(:delete, 'core', 'models',  Oj.dump(name:"Supporter"))
        @client.destroy
      end

      def test_validation
        with_api(Upsert,@api_options) do
          body = { data: Oj.dump({}) }
          post_request({path: '/supporters', head: @headrw, body: body }, @err) do |c|
            assert_equal 406, c.response_header.status
            assert_equal  '{"errors":{"validation":{"first_name":{"required":true}}}}', c.response
          end
        end
      end

      def test_insert
        with_api(Upsert,@api_options) do
          
          body = { first_name: "Lemmy" }
          
          post_request({path: '/supporters', head: @headrw, body: body }, @err) do |c|
            assert_equal 200, c.response_header.status
            assert_match /11/, DB::Set['supporters'].query({select: "COUNT(id)"})
          end
        end
      end

      def test_update
        # body = { 'user' => Oj.dump({ 'select' => '*' }) }
        with_api(Upsert,@api_options) do
          body = { uuid: @uuid, first_name: "Bonzo", last_name: "Boke" }
          put_request({path: '/supporters', head: @headrw, body: body }, @err) do |c|
            assert_equal 200, c.response_header.status
            assert_match /uuid/, c.response
          end
        end
      end
      
    end
  end
end