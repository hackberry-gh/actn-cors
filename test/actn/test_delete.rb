require 'minitest_helper'
require 'goliath/test_helper'
require 'apis/delete'
require 'actn/api/client'
require 'actn/db'

module Actn
  module Api
    class TestDelete < MiniTest::Test
      
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
        
        @uuid =  Oj.load(DB::Set['supporters'].query({select: ['uuid'], limit: 1}))[0]['uuid']
    
        @api_options = { :verbose => true, :log_stdout => true, config: "#{Actn::Api.root}/config/common.rb" }
        @err = Proc.new { assert false, "API request failed" }
    
        @client = Client.create({domain: "localhost:9900"})
        @headr = { 'X_APIKEY' => @client.credentials['apikey'] }
        @headrw = { 'X_APIKEY' => @client.credentials['apikey'], 'X_SECRET' => @client.credentials['secret'] }
      end
  
      def teardown
        DB.exec_func(:delete, 'core', 'models',  Oj.dump(name:"Supporter"))
        @client.destroy
      end

      def test_remove
        with_api(Delete,@api_options) do    
          delete_request({path: '/supporters', head: @headrw, query: { 'uuid' => @uuid} }, @err) do |c|
            assert_equal 200, c.response_header.status
            assert_match /9/, DB::Set['supporters'].count
          end 
        end
      end
      
    end
  end
end