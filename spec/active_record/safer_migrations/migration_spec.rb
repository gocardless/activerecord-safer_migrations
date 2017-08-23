# frozen_string_literal: true

require "spec_helper"

RSpec.describe ActiveRecord::SaferMigrations::Migration do
  let(:migration_base_class) do
    if ActiveRecord.version >= Gem::Version.new("5.0")
      ActiveRecord::Migration[ActiveRecord::Migration.current_version]
    else
      ActiveRecord::Migration
    end
  end

  before { nuke_migrations }
  before { TimeoutTestHelpers.set(:lock_timeout, 0) }
  before { TimeoutTestHelpers.set(:statement_timeout, 0) }

  describe "setting timeouts explicitly" do
    before { $lock_timeout = nil }
    before { $statement_timeout = nil }

    shared_examples_for "running the migration" do
      let(:migration) do
        Class.new(migration_base_class) do
          set_lock_timeout(5000)
          set_statement_timeout(5001)

          def change
            $lock_timeout = TimeoutTestHelpers.get(:lock_timeout)
            $statement_timeout = TimeoutTestHelpers.get(:statement_timeout)
          end
        end
      end

      it "sets the lock timeout for the duration of the migration" do
        silence_stream($stdout) { run_migration.call }
        expect($lock_timeout).to eq(5000)
      end

      it "unsets the lock timeout after the migration" do
        silence_stream($stdout) { run_migration.call }
        expect(TimeoutTestHelpers.get(:lock_timeout)).to eq(0)
      end

      it "sets the statement timeout for the duration of the migration" do
        silence_stream($stdout) { run_migration.call }
        expect($statement_timeout).to eq(5001)
      end

      it "unsets the statement timeout after the migration" do
        silence_stream($stdout) { run_migration.call }
        expect(TimeoutTestHelpers.get(:statement_timeout)).to eq(0)
      end

      context "when the original timeout is not 0" do
        before { TimeoutTestHelpers.set(:lock_timeout, 8000) }
        before { TimeoutTestHelpers.set(:statement_timeout, 8001) }

        it "unsets the lock timeout after the migration" do
          silence_stream($stdout) { run_migration.call }
          expect(TimeoutTestHelpers.get(:lock_timeout)).to eq(8000)
        end

        it "unsets the statement timeout after the migration" do
          silence_stream($stdout) { run_migration.call }
          expect(TimeoutTestHelpers.get(:statement_timeout)).to eq(8001)
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

  describe "the default timeouts" do
    before { $lock_timeout = nil }
    before { $statement_timeout = nil }
    before { ActiveRecord::SaferMigrations.default_lock_timeout = 6000 }
    before { ActiveRecord::SaferMigrations.default_statement_timeout = 6001 }
    let(:migration) do
      Class.new(migration_base_class) do
        def change
          $lock_timeout = TimeoutTestHelpers.get(:lock_timeout)
          $statement_timeout = TimeoutTestHelpers.get(:statement_timeout)
        end
      end
    end

    it "sets the lock timeout for the duration of the migration" do
      silence_stream($stdout) { migration.migrate(:up) }
      expect($lock_timeout).to eq(6000)
    end

    it "unsets the lock timeout after the migration" do
      silence_stream($stdout) { migration.migrate(:up) }
      expect(TimeoutTestHelpers.get(:lock_timeout)).to eq(0)
    end

    it "sets the statement timeout for the duration of the migration" do
      silence_stream($stdout) { migration.migrate(:up) }
      expect($statement_timeout).to eq(6001)
    end

    it "unsets the statement timeout after the migration" do
      silence_stream($stdout) { migration.migrate(:up) }
      expect(TimeoutTestHelpers.get(:statement_timeout)).to eq(0)
    end
  end

  describe "when inheriting from a migration with timeouts defined" do
    before { $lock_timeout = nil }
    before { $statement_timeout = nil }
    before { ActiveRecord::SaferMigrations.default_lock_timeout = 6000 }
    before { ActiveRecord::SaferMigrations.default_statement_timeout = 6001 }
    let(:base_migration) do
      Class.new(migration_base_class) do
        set_lock_timeout(7000)
        set_statement_timeout(7001)
        def change
          $lock_timeout = TimeoutTestHelpers.get(:lock_timeout)
          $statement_timeout = TimeoutTestHelpers.get(:statement_timeout)
        end
      end
    end

    context "when the timeout isn't overridden" do
      let(:migration) { Class.new(base_migration) {} }

      it "sets the base class' lock timeout for the duration of the migration" do
        silence_stream($stdout) { migration.migrate(:up) }
        expect($lock_timeout).to eq(7000)
      end

      it "sets the base class' statement timeout for the duration of the migration" do
        silence_stream($stdout) { migration.migrate(:up) }
        expect($statement_timeout).to eq(7001)
      end
    end

    context "when the timeout is overridden" do
      let(:migration) do
        Class.new(base_migration) do
          set_lock_timeout(8000)
          set_statement_timeout(8001)
        end
      end

      it "sets the subclass' lock timeout for the duration of the migration" do
        silence_stream($stdout) { migration.migrate(:up) }
        expect($lock_timeout).to eq(8000)
      end

      it "sets the subclass' statement timeout for the duration of the migration" do
        silence_stream($stdout) { migration.migrate(:up) }
        expect($statement_timeout).to eq(8001)
      end
    end
  end
end
