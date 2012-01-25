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
  		
  		Encoding.default_internal = nil
  		Encoding.default_external = "UTF-8"
  		new(hash) 

  	end # self.connection

  end	# Protocol

end # Anubis

module Mysql2

  class Result

    def self.force_encode_to_utf8(target)

      traverse = lambda do |object, block|
        
        if object.kind_of?(Hash)
          object.each_value { |o| traverse.call(o, block) }
        elsif object.kind_of?(Array)
          object.each { |o| traverse.call(o, block) }
        else
          block.call(object)
        end
        object

      end # traverse

      force_encoding = lambda do |o|
        o.force_encoding(Encoding::UTF_8) if o.respond_to?(:force_encoding)
      end

      traverse.call(target, force_encoding)
      target

    end # self.force_encode_to_utf8

  	def first
  		
  		r = super
  		self.class.force_encode_to_utf8(r)
  		r

  	end	# first
    
    def to_a

    	r = super
    	self.class.force_encode_to_utf8(r)
    	r

    end	# to_a

  end # Result
  	
end # Mysql2