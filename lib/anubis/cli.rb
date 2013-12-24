# encoding: utf-8
require ::File.expand_path('../commands_tasks', __FILE__)

module Anubis

  class Cli

HELP_MESSAGE = <<-EOT
Usage: anubis COMMAND

 config      Generate Sphinx config
 start       Starting Sphinx
 stop        Stopping Sphinx
 restart     Restaring Sphinx

 drop        Drop all Sphinx indexes
 create      Create all Sphinx indexes
 rebuild     Rebuild all Sphinx indexes

EOT

    def initialize(argv)
      @argv = argv
    end # new

    def run!

      case @argv.shift

        when 'config'   then ::Anubis::CommandsTasks.config
        when 'start'    then ::Anubis::CommandsTasks.start
        when 'stop'     then ::Anubis::CommandsTasks.stop
        when 'restart'  then ::Anubis::CommandsTasks.restart
        when 'drop'     then ::Anubis::CommandsTasks.drop
        when 'create'   then ::Anubis::CommandsTasks.create
        when 'rebuild'  then ::Anubis::CommandsTasks.rebuild

        else
          puts ::Anubis::Cli::HELP_MESSAGE
          exit(1)

      end

    end # run!

  end # Cli

end # Anubis
