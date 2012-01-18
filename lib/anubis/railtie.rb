# encoding: utf-8
require 'rails'

module ActsAsFiles

  class Railtie < ::Rails::Railtie #:nodoc:
    
    rake_tasks do
      load File.expand_path('../../tasks/anubis.rake', __FILE__)
    end

  end # Railtie

end # ActsAsFiles