# encoding: utf-8
namespace :anubis do

  desc 'Generate Sphinx config'
  task :config => :environment do

    puts
    puts "Generating sphinx config #{Anubis.sphinx_conf}... "
    puts (Anubis.configure ? "Success" : "Failure")
    puts

  end # :config

  desc 'Starting Sphinx'
  task :start => :environment do

    puts
    puts "Starting sphinx..."
    puts Anubis.start
    
  end # :start

  desc 'Stopping Sphinx'
  task :stop => :environment do

    puts
    puts "Stopping sphinx..."
    puts Anubis.stop
    
  end # :stop

  desc 'Restaring Sphinx'
  task :restart => :environment do
    
    puts
    puts "Restaring sphinx..."
    puts Anubis.stop
    sleep 3
    puts Anubis.start

  end # :restart

  desc 'Drop all Sphinx indexes'
  task :drop => :environment do
    
    puts
    puts Anubis.stop
    sleep 3
    Anubis.drop_all
    
  end # :restart  

  desc 'Create all Sphinx indexes'
  task :create => :environment do
    
    puts
    puts Anubis.stop
    sleep 3
    Anubis.create_all
    
  end # :restart  

  desc 'Rebuild all Sphinx indexes'
  task :rebuild => :environment do
    
    puts
    puts Anubis.stop
    sleep 3
    Anubis.drop_all
    Rake::Task["anubis:config"].invoke
    Anubis.create_all
    puts Anubis.start

  end # :restart  

end # :anubis