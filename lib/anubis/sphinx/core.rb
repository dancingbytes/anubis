# encoding: utf-8
module Anubis

  module SphinxCore

    extend self

    SEARCHD = 'searchd'.freeze

    def searchd

      return @bin if @bin

      @bin = which
      raise ::Anubis::SphinxError.new("#{SEARCHD} does not found") if @bin.nil? || @bin.empty?
      @bin

    end # searchd

    private

    def which
      %x{which #{SEARCHD}}.chomp
    end # which

  end # SphinxCore

end # Anubis
