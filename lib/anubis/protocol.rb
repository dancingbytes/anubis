# encoding: utf-8
require 'mysql2/em'
require 'em-synchrony'
require 'em-synchrony/mysql2'

module Anubis

	class SphinxError < ::Mysql2::Error

    def error
      s = super
      s.gsub(/MySQL/, 'Sphinx')
    end # error

  end # SphinxError

  class Protocol < ::Mysql2::EM::Client

  	def self.connection(hash = {})

      poolsize = hash.delete(:poolsize) || 4
      hash[:flags] = ::Mysql2::Client::REMEMBER_OPTIONS | ::Mysql2::Client::LONG_PASSWORD | ::Mysql2::Client::LONG_FLAG | ::Mysql2::Client::TRANSACTIONS | ::Mysql2::Client::PROTOCOL_41 | ::Mysql2::Client::SECURE_CONNECTION | ::Mysql2::Client::MULTI_STATEMENTS

  		::EventMachine::Synchrony::ConnectionPool.new(size: poolsize) do
  		  new(hash)
      end

  	end # self.connection

  end	# Protocol

end # Anubis