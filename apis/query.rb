require 'actn/api/cors'
 
class Query < Actn::Api::Cors

  use Rack::Static, :root => "#{Actn::Api.root}/public", :urls => ['favicon.ico']    
  use Goliath::Rack::Validation::RequestMethod, %w(GET HEAD OPTIONS)

  ##
  # GET /table_name?query={ where: { uuid: 1 } }
  
  def process table, path
    
    unless query['unscoped']
      
      query['where'] ||= {}
      
      query['where']['path'] = path
      
    end
    
    query['limit'] ||= limit
    query['offset'] = offset
    
    Actn::DB::Set[table].query(query)
  end
  
end