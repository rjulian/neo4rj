# frozen_string_literal: true

require_relative '../neo4rj.rb'

RSpec.describe Neo4rj do
  context 'it creates a valid http listener' do
    it 'has a port exposed on 7474' do
    end
    it 'requires the proper headers for http comms' do
    end
    it 'returns the same response no matter the query passed' do
    end
  end
  context 'it creates a valid bolt protocol listener' do
    it 'has a port explosed on 7658' do
    end
  end
  context 'it logs all connection information' do
    it 'creates a log file on start' do
      neo4rj = Neo4rj.new
      logger = neo4rj.instance_variable_get(:@logger)
      expect(logger.level).to eq(0)
      expect(logger.progname).to eq('neo4rj')
      neo4rj = nil
    end
    it 'logs IP address for a connection' do
    end
    it 'logs credentials used for a connection' do
    end
    it 'logs payloads of queries' do
    end
  end
  it 'allows access with any bad credentials pairs' do
  end
end
