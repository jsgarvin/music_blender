require 'test_helper'

module MusicBlender
  class DbAdapterTest < MiniTest::Unit::TestCase

    describe DbAdapter do
      let(:mock_connection) { mock('db_connection') }
      let(:adapter) { DbAdapter.new }

      before do
        ActiveRecord::Base.stubs(:establish_connection).returns(mock_connection)
        ActiveRecord::Base.stubs(:connection).returns(mock_connection)
        ActiveRecord::Base.stubs('logger').returns(true)
      end

      def test_spinup_without_prior_db
        File.expects(:exist?).returns(false)
        adapter.expects(:load)
        ActiveRecord::Migrator.expects(:migrate).never

        adapter.spin_up
      end

      def test_spinup_with_prior_db
        File.expects(:exist?).returns(true)
        ActiveRecord::Migrator.expects(:migrate)
        File.expects(:open).with(adapter.send(:path_to_schema),'w:utf-8').yields(mock('schema_file'))
        ActiveRecord::SchemaDumper.expects(:dump)
        adapter.expects(:load).never

        adapter.spin_up
      end
    end

  end
end

