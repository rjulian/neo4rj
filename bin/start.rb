require './lib/neo4rj'

instance = Neo4rj.new

thread = Thread.new do
  instance.start_http_service
end

instance.start_bolt_service
thread.join
