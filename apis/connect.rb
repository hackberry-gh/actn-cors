require 'actn/api/cors'
require 'actn/core_ext/string'
require 'goliath/rack/templates' 
require 'tilt/erb' 

class Connect < Actn::Api::Cors
  
  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => ['favicon.ico']      
  include Goliath::Rack::Templates  
  
  ##
  # GET /connect.js, renders actn.io js api client
  
  def response(env)
    authorize!
    
    [
      200, CT_JS, erb(:connect, {}, { 
      
      host: env['HTTP_HOST'],       apikey: query['apikey'], 
      
      csrf: Rack::Csrf.token(env),  ttl: Client::TTL * 1000 
      
      } ) 
    ]
  end
  
  private
  
  def authorize!
    begin
      puts env['HTTP_REFERER'].to_domain.inspect, query['apikey']
      client = Client.find_for_auth(env['HTTP_REFERER'].to_domain, query['apikey'])
      puts client.inspect
      client.set_session env['rack.session'].id
    rescue Exception => e
      env.logger.error e.inspect
      raise Goliath::Validation::UnauthorizedError.new
    end
  end
  
end