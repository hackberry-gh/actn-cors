require 'minitest_helper'
require 'goliath/test_helper'
require 'apis/query'
require 'actn/api/client'
require 'actn/db'
require 'log4r'
module Actn
  module Api
    class TestQuery < MiniTest::Test
      
      include Goliath::TestHelper

      def setup

        DB.exec_func(:upsert, 'core', 'models', Oj.dump({name: "Supporter"}))
    
        10.times{ |i| DB::Set['supporters'].upsert({path: "/supporters", name: "supporter_#{random_str}"}) }
        DB::Set['supporters'].upsert({path: "/supporters/customs", name: "user_#{random_str}"})        
    
        @api_options = { :verbose => true, :log_stdout => true, config: "#{Actn::Api.root}/config/common.rb" }
        @err = Proc.new { assert false, "API request failed" }
        @client = Client.create({domain: "localhost:9900"})
        @headr = { 'X_APIKEY' => @client.credentials['apikey'] }
        
        @query = { 'query' => Oj.dump({ 'select' => '*' }) }

      end
  
      def teardown

        DB.exec_func(:delete, 'core', 'models',  Oj.dump(name:"Supporter"))
        @client.destroy

      end
  
      def test_query

        with_api(Query,@api_options) do
          get_request({path: '/supporters', head: @headr, query: @query }, @err) do |c|
            assert_equal 200, c.response_header.status
            assert_equal 10, Oj.load(c.response).size
          end
        end
        
      end
  
      def test_path

        with_api(Query,@api_options) do

          get_request({path: '/supporters/customs', head: @headr, query: @query }, @err) do |c|
            assert_equal 200, c.response_header.status
            assert_equal 1, Oj.load(c.response).size
          end
        end
      end

    end
  end
end