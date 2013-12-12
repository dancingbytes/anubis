# encoding: utf-8
module Anubis

  module CommandsTasks

    extend self

    def config

      puts
      puts "Generating sphinx config #{::Anubis.sphinx_conf}... "
      raise ::Anubis::SphinxError.new("Error generate sphinx config") unless ::Anubis.configure
      puts "Ok"

    end # config

    def start

      puts
      puts "Starting sphinx..."
      ::Anubis.start

    end # start

    def stop

      puts
      puts "Stopping sphinx..."
      ::Anubis.stop

    end # stop

    def restart

      self.stop
      sleep 3
      self.start

    end # :restart

    def drop

      self.stop
      sleep 3
      puts "Droping all Sphinx indexes..."
      ::Anubis.drop_all

    end # drop

    def create

      self.stop
      sleep 3
      puts "Creating all Sphinx indexes..."
      ::Anubis.create_all

    end # :create

    def rebuild

      self.stop
      self.config

      puts "Creating all Sphinx indexes..."
      ::Anubis.create_all

      sleep 3
      self.start

    end # rebuild

  end # CommandsTasks

end # Anubis
