# frozen_string_literal: true
require 'net/http'
require './lib/neo4rj'

RSpec.describe Neo4rj do
  before do
    @neo4rj = Neo4rj.new
    Thread.new do
      @neo4rj.start_http_service
    end
  end

  it 'creates a log file on start' do
    logger = @neo4rj.instance_variable_get(:@logger)
    expect(logger.level).to eq(0)
    expect(logger.progname).to eq('neo4rj')
  end

  it 'has a delivery payload' do
    expect(@neo4rj.payload).not_to be_nil
  end

  it 'returns the expected payload' do
    uri = URI('http://localhost:7474')
    Net::HTTP.start(uri.host, uri.port) do |http|
      request = Net::HTTP::Get.new uri
      response = http.request request
      expect(response.body.include?('management')).to eq(true)
      expect(response.code).to eq('200')
    end
  end
end
