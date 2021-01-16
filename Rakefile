require 'active_record'

namespace :db do
  db_config = YAML.load(File.open('config/database.yml'))

  task :migrate do
    ActiveRecord::Base.establish_connection(db_config)
    migrations = ActiveRecord::Migration.new.migration_context.migrations
    ActiveRecord::Migrator.new(:up, migrations, nil).migrate

    puts 'Database migrated.'
  end

  task :create do
    admin_connection = db_config.merge(database: 'postgres', schema_search_path: 'public')
    ActiveRecord::Base.establish_connection(admin_connection)
    ActiveRecord::Base.connection.create_database(db_config.fetch('database'))
  end
end
