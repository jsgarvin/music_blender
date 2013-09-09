require 'test_helper'

module MyMusicPlayer
  class DbAdapterTest < MiniTest::Unit::TestCase
    attr_reader :db_adapter

    def setup
      mock_connection = mock('db_connection')
      ActiveRecord::Base.stubs(:establish_connection).returns(mock_connection)
      ActiveRecord::Base.stubs(:connection).returns(mock_connection)
      ActiveRecord::Base.stubs('logger').returns(true)
      @db_adapter = DbAdapter.new
    end

    def test_spinup_without_prior_db
      File.expects(:exist?).returns(false)
      db_adapter.expects(:load)
      ActiveRecord::Migrator.expects(:migrate).never

      db_adapter.spin_up
    end

    def test_spinup_with_prior_db
      File.expects(:exist?).returns(true)
      ActiveRecord::Migrator.expects(:migrate)
      File.expects(:open).with(db_adapter.send(:path_to_schema),'w:utf-8').yields(mock('schema_file'))
      ActiveRecord::SchemaDumper.expects(:dump)
      db_adapter.expects(:load).never

      db_adapter.spin_up
    end

  end
end

