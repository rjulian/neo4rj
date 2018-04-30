# frozen_string_literal: true

require './lib/neo4rj'

RSpec.describe Neo4rj do
  context 'it logs all connection information' do
    it 'creates a log file on start' do
      neo4rj = Neo4rj.new
      logger = neo4rj.instance_variable_get(:@logger)
      expect(logger.level).to eq(0)
      expect(logger.progname).to eq('neo4rj')
      neo4rj = nil
    end
  end
end
