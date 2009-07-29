namespace :geonames do
  desc 'Generate and install migrations, then download and import all data (except for geonames:import:features)'
  task :install => [:migrate, 'import:all']
end