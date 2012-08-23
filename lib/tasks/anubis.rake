# encoding: utf-8
namespace :anubis do

  desc 'Generate Sphinx config'
  task :config => :environment do

    puts
    puts "Generating sphinx config #{Anubis.sphinx_conf}... "
    raise ::Anubis::SphinxError.new("Error generate sphinx config") unless Anubis.configure
    puts "Ok"

  end # :config

  desc 'Starting Sphinx'
  task :start => :environment do

    puts
    puts "Starting sphinx..."
    Anubis.start

  end # :start

  desc 'Stopping Sphinx'
  task :stop => :environment do

    puts
    puts "Stopping sphinx..."
    Anubis.stop

  end # :stop

  desc 'Restaring Sphinx'
  task :restart => :environment do

    Rake::Task["anubis:stop"].invoke
    sleep 2
    Rake::Task["anubis:start"].invoke

  end # :restart

  desc 'Drop all Sphinx indexes'
  task :drop => :environment do

    Rake::Task["anubis:stop"].invoke

    sleep 2

    puts "Droping all Sphinx indexes..."
    Anubis.drop_all

  end # :restart

  desc 'Create all Sphinx indexes'
  task :create => :environment do

    Rake::Task["anubis:stop"].invoke

    sleep 2

    puts "Creating all Sphinx indexes..."
    Anubis.create_all

  end # :restart

  desc 'Rebuild all Sphinx indexes'
  task :rebuild => :environment do

    Rake::Task["anubis:drop"].invoke
    Rake::Task["anubis:config"].invoke

    puts "Creating all Sphinx indexes..."
    Anubis.create_all

    Rake::Task["anubis:start"].invoke

  end # :restart

end # :anubis