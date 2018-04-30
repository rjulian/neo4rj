# frozen_string_literal: true
require 'socket'
require 'logger'
require 'base64'
require 'securerandom'

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
        trans_id = SecureRandom.uuid
        method, path = client.gets.split
        puts path
				puts method
				headers = {}
				while line = client.gets.split(' ', 2)
					break if line[0] == ""
					headers[line[0].chop] = line[1].strip
				end
				puts headers
				remote_ip = client.peeraddr[3]
				remote_port = client.peeraddr[1]
        @logger.info("#{trans_id}:Connection from #{remote_ip}:#{remote_port}.")
        if headers['Authorization']
          b64_auth = headers['Authorization'].gsub('Basic ','')
          auth_string = Base64.decode64(b64_auth)
          @logger.info("#{trans_id}:Attempted authentication #{auth_string}.")
        end
        client.puts payload
        client.close
      end
    end
  end
end
