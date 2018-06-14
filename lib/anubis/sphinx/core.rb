# encoding: utf-8
module Anubis

  module SphinxCore

    extend self

    SEARCHD = 'searchd'.freeze

    def searchd
      
      return @bin if @bin

      @bin = which
      @bin = whereis if @bin.nil? || @bin.empty?
      @bin

    end # searchd

    private

    def which
      `which #{SEARCHD}`.chomp
    end # which

    def whereis
      `whereis #{SEARCHD}`.chomp
    end # whereis

  end # SphinxCore

end # Anubis
