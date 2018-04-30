# frozen_string_literal: true
require 'socket'
require 'logger'
# Implements a fake service neo4j running on our local machine
class Neo4rj
  def initialize
    @logger = Logger.new('| tee neo4rj.log', 'weekly', progname: 'neo4rj')
  end

  def start_mock_http_service
    payload =  %{HTTP/1.1 200 OK
Content-Type: text;charset=utf-8
Content-Length: 137

\{
  "management" : "http://localhost:7474/db/manage/",
  "data" : "http://localhost:7474/db/data/",
  "bolt" : "bolt://localhost:7687"
\}}
    @logger.info 'Starting neo4rj service on port 7474'
    mock_http_server = TCPServer.new 7474
    loop do
      Thread.start(mock_http_server.accept) do |client|
        remote_ip = client.peeraddr[3]
        remote_port = client.peeraddr[1]
        @logger.info("Connection from #{remote_ip}:#{remote_port}.")
        client.puts payload
        client.close
      end
    end
  end
end
