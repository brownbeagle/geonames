namespace :geonames do
  desc 'Copy over the migration files and migrate'
  task :migrate => [:environment, :copy_migrations, 'db:migrate']

  # Inspired by http://interblah.net/plugin-migrations
  desc 'Copy over the migration files and migrate'
  task :copy_migrations => :environment do
    # Find all application migrations
    existing_migrations = Dir["#{RAILS_ROOT}/db/migrate/*"]
    existing_migrations.map!{|file| File.basename(file) =~ /^[0-9]+_(.+)$/ && $1}
    # Find all of this pluing's migrations
    plugin_migrations = Dir["#{File.dirname(__FILE__)}/../../db/migrate/*"]
    plugin_migrations.map!{|file| File.basename(file)}
    # Compare application migrations with this plugins set of migrations, and copy new migrations.
    base_time = Time.now
    (plugin_migrations - existing_migrations).each do |new_migration|
      migration_timestamp = base_time.strftime('%Y%m%d%H%M%S')
      File.copy "#{RAILS_ROOT}/db/migrate", "#{migration_timestamp}_#{new_migration}"
      base_time+=1
    end
  end
end