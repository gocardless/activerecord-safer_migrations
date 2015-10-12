require "spec_helper"

RSpec.describe ActiveRecord::SaferMigrations::Migration do
  before { nuke_migrations }
  before { LockTestHelpers.set_timeout(0) }

  describe ".lock_timeout" do
    before { $test_result = nil }

    shared_examples_for "running the migration" do
      let(:migration) do
        Class.new(ActiveRecord::Migration) do
          lock_timeout(5000)

          def change
            $test_result = LockTestHelpers.get_timeout
          end
        end
      end

      it "sets the lock timeout for the duration of the migration" do
        silence_stream($stdout) { run_migration.call }
        expect($test_result).to eq(5000)
      end

      it "unsets the lock timeout after the migration" do
        silence_stream($stdout) { run_migration.call }
        expect(LockTestHelpers.get_timeout).to eq(0)
      end

      context "when the original timeout is not 0" do
        before { LockTestHelpers.set_timeout(8000) }

        it "unsets the lock timeout after the migration" do
          silence_stream($stdout) { run_migration.call }
          expect(LockTestHelpers.get_timeout).to eq(8000)
        end
      end
    end

    context "when running with transactional DDL" do
      let(:run_migration) do
        -> { ActiveRecord::Base.transaction { migration.migrate(:up) } }
      end

      include_examples "running the migration"
    end

    context "when running without transactional DDL" do
      let(:run_migration) { -> { migration.migrate(:up) } }

      include_examples "running the migration"
    end
  end


  describe "the default lock timeout" do
    before { $test_result = nil }
    before { ActiveRecord::SaferMigrations.default_lock_timeout = 6000 }
    let(:migration) do
      Class.new(ActiveRecord::Migration) do
        def change
          $test_result = LockTestHelpers.get_timeout
        end
      end
    end

    it "sets the lock timeout for the duration of the migration" do
      silence_stream($stdout) { migration.migrate(:up) }
      expect($test_result).to eq(6000)
    end

    it "unsets the lock timeout after the migration" do
      silence_stream($stdout) { migration.migrate(:up) }
      expect(LockTestHelpers.get_timeout).to eq(0)
    end
  end
end
