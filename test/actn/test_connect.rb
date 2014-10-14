require 'minitest_helper'
require 'goliath/test_helper'
require 'apis/cors/connect'
require 'actn/api/client'
require 'actn/db'

module Actn
  module Api
    class TestConnect < MiniTest::Test
      
      include Goliath::TestHelper

      def setup
    
        @api_options = { :verbose => true, :log_stdout => true, config: "#{Actn::Api.root}/config/core.rb" }
        @err = Proc.new { assert false, "API request failed" }
        @client = Client.create({domain: "localhost:9900"})

      end
  
      def teardown


        @client.destroy

      end
  
      def test_not_connect_because_referer_check

        with_api(Connect,@api_options) do
          get_request({path: '/connect', query: { 'apikey' => @client.credentials['apikey'] } }, @err) do |c|
            assert_equal 401, c.response_header.status
          end
        end
        
      end
  
      

    end
  end
end