# encoding: utf-8
module Anubis

  class SphinxError < ::Mysql2::Error 

    def error
      s = super
      s.gsub(/MySQL/, 'Sphinx')
    end # error

  end # SphinxError

end # Anubis