# encoding: utf-8
require ::File.expand_path('../../anubis/commands_tasks', __FILE__)

namespace :anubis do

  desc 'Generate Sphinx config'
  task :config => :environment do

    ::Anubis::CommandsTasks.config

  end # :config

  desc 'Starting Sphinx'
  task :start => :environment do

    ::Anubis::CommandsTasks.start

  end # :start

  desc 'Stopping Sphinx'
  task :stop => :environment do

    ::Anubis::CommandsTasks.stop

  end # :stop

  desc 'Restaring Sphinx'
  task :restart => :environment do

    ::Anubis::CommandsTasks.restart

  end # :restart

  desc 'Drop all Sphinx indexes'
  task :drop => :environment do

    ::Anubis::CommandsTasks.drop

  end # :restart

  desc 'Create all Sphinx indexes'
  task :create => :environment do

    ::Anubis::CommandsTasks.create

  end # :restart

  desc 'Rebuild all Sphinx indexes'
  task :rebuild => :environment do

    ::Anubis::CommandsTasks.rebuild

  end # :restart

end # :anubis
