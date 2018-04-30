# frozen_string_literal: true

require './lib/neo4rj'

RSpec.describe Neo4rj do
  before do
    @neo4rj = Neo4rj.new
  end


  it 'creates a log file on start' do
    logger = @neo4rj.instance_variable_get(:@logger)
    expect(logger.level).to eq(0)
    expect(logger.progname).to eq('neo4rj')
  end

end
