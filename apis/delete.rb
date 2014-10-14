require 'actn/api/cors'
 
class Delete < Actn::Api::Cors

  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => ['favicon.ico']    
  use Goliath::Rack::Validation::RequestMethod, %w(DELETE OPTIONS)
  
  ##
  # GET /table_name?query={ where: { uuid: 1 } }
  
  def process table, path
    
    Actn::DB::Set[table].delete({uuid: query['uuid']})
  end
  
end