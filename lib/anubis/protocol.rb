# encoding: utf-8
require 'mysql2'

module Anubis

	class SphinxError < ::Mysql2::Error

    def error
      s = super
      s.gsub(/MySQL/, 'Sphinx')
    end # error

  end # SphinxError

  class Protocol < ::Mysql2::Client

    def self.connection(hash = {})

      ::Encoding.default_internal = "UTF-8"
      ::Encoding.default_external = "UTF-8"

      hash[:flags]  = ::Mysql2::Client::REMEMBER_OPTIONS
#      hash[:flags] |= ::Mysql2::Client::LONG_PASSWORD
#      hash[:flags] |= ::Mysql2::Client::LONG_FLAG
      hash[:flags] |= ::Mysql2::Client::FOUND_ROWS
      hash[:flags] |= ::Mysql2::Client::TRANSACTIONS
      hash[:flags] |= ::Mysql2::Client::PROTOCOL_41
      hash[:flags] |= ::Mysql2::Client::SECURE_CONNECTION
      hash[:flags] |= ::Mysql2::Client::MULTI_STATEMENTS

      hash.delete(:async)
      new(hash)

    end # self.connection

  end # Protocol

end # Anubis
