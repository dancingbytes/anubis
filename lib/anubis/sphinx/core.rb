# encoding: utf-8
module Anubis

  module SphinxCore

    extend self

    SEARCHD = 'searchd'.freeze

    def searchd
      @bin ||= which || whereis
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
