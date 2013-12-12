# encoding: utf-8
module Anubis

  class SphinxVersion

    REG = /Sphinx (\d+)\.(\d+)(?:\.(\d+)(\S+))\s\(r(\d+)\)/.freeze

    def initialize

      @bin = ::Anubis::SphinxCore.searchd
      parse

    end # new

    def major
      @major
    end # major

    def minor
      @minor
    end # minor

    def patch
      @patch
    end # patch

    def rev
      @rev
    end # rev

    def version
      @version
    end # version

    def dev?
      @dev == true
    end # dev?

    def id64?
      @id64 == true
    end # id64?

    def beta?
      @beta == true
    end # beta?

    def release?
      @release == true
    end # release?

    private

    def cmd
      `#{@bin} --help`.chomp
    end # cmd

    def parse

      @match    = cmd.match(::Anubis::SphinxVersion::REG)

      @major    = @match[1].to_i rescue 0
      @minor    = @match[2].to_i rescue 0
      @patch    = @match[3].to_i rescue 0
      @rev      = @match[5].to_i rescue 0
      @version  = [@major, @minor, @patch].join(".")

      mt        = @match[4] || ""
      @dev      = mt.include?("dev")
      @id64     = mt.include?("id64")
      @beta     = mt.include?("beta")
      @release  = mt.include?("release")

    end # parse

  end # SphinxVersion

end # Anubis
