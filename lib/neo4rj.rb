# frozen_string_literal: true
require 'socket'
require 'logger'
require 'base64'
require 'securerandom'

# Implements a fake service neo4j running on our local machine
class Neo4rj
  def initialize
    @logger = Logger.new(STDOUT, 'weekly', progname: 'neo4rj')
  end

  def payload
    %{HTTP/1.1 200 OK
Content-Type: text;charset=utf-8
Content-Length: 137

\{
  "management" : "http://localhost:7474/db/manage/",
  "data" : "http://localhost:7474/db/data/",
  "bolt" : "bolt://localhost:7687"
\}}
  end

  def start_http_service
    @logger.info 'Starting neo4rj http service on port 7474'
    mock_http_server = TCPServer.new 7474
    loop do
      create_threads(mock_http_server)
    end
  end

  def create_threads(server)
    Thread.start(server.accept) do |client|
      @trans_id = SecureRandom.uuid
      handle_conn_metadata(client)
      client.puts payload
      stop_http_service(client)
    end
  end

  def start_bolt_service
    @logger.info 'Starting neo4rj bolt service on port 7687'
    mock_bolt_server = TCPServer.new 7687
    loop do
      create_threads(mock_bolt_server)
    end
  end

  def handle_conn_metadata(connection)
    headers = collect_headers(connection)

    remote_ip = connection.peeraddr[3]
    remote_port = connection.peeraddr[1]
    @logger.info("#{@trans_id}:Connection from #{remote_ip}:#{remote_port}.")
    if headers['Authorization']
      b64_auth = headers['Authorization'].gsub('Basic ','')
      auth_string = Base64.decode64(b64_auth)
      @logger.info("#{@trans_id}:Attempted authentication #{auth_string}.")
    end
  end

  def collect_headers(connection)
    headers = {}
    while line = connection.gets.split(' ', 2)
      break if line[0] == ""
      headers[line[0].chop] = line[1].strip
    end
    headers
  end

  def stop_http_service(connection)
    @logger.debug("#{@trans_id}:Ending http connection.")
    connection.close
  end
end
