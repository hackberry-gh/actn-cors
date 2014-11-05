require 'actn/api/cors'
 
class Delete < Actn::Api::Cors

  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => ['favicon.ico']    
  use Goliath::Rack::Validation::RequestMethod, %w(DELETE OPTIONS)
  
  ##
  # DELETE /table_name?uuid=1
  
  def process table, path
    Actn::DB::Set[table].delete({uuid: data['uuid']})
  end
  
end