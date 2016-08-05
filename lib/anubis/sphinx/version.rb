# encoding: utf-8
module Anubis

  class SphinxVersion

    REG_SPHINX = /^Sphinx (\d+)\.(\d+)(?:\.(\d+)(\S+))\s\((.*r{0,1}\w+|\w+)\)/.freeze
    REG_STRING = /\A(\d+)(?:\.(\d+)(?:\.(\d+)(?:(\S+))?(?:\s\(r(\d+)\))?)?)?\Z/.freeze

    def self.cache_versions
      @cache_versions ||= {}
    end # self.cache_versions

    def initialize(ver = nil)

      @bin = ::Anubis::SphinxCore.searchd
      if ver.nil?
        parse(cmd, REG_SPHINX)
      else
        parse(ver, REG_STRING)
      end

    end # new

    def ==(val)

      ver = to_version(val)

      return false if  ver.major.nil? || self.major != ver.major
      return false if !ver.minor.nil? && self.minor != ver.minor
      return false if !ver.patch.nil? && self.patch != ver.patch

      true

    end # ==

    def ===(val)

      ver = to_version(val)

      return false if  ver.major.nil? || self.major != ver.major
      return false if !ver.minor.nil? && self.minor != ver.minor
      return false if !ver.patch.nil? && self.patch != ver.patch

      return false if self.dev?     != ver.dev?
      return false if self.id64?    != ver.id64?
      return false if self.beta?    != ver.beta?
      return false if self.release? != ver.release?

      true

    end # ===

    def >(val)

      ver = to_version(val)

      return false if  ver.major.nil? || self.major < ver.major
      return false if !ver.minor.nil? && self.minor < ver.minor
      return false if !ver.patch.nil? && self.patch <= ver.patch
      true

    end # >

    def >=(val)

      ver = to_version(val)

      return false if  ver.major.nil? || self.major < ver.major
      return false if !ver.minor.nil? && self.minor < ver.minor
      return false if !ver.patch.nil? && self.patch < ver.patch

      true

    end # >=

    def <(val)

      ver = to_version(val)

      return false if  ver.major.nil? || self.major > ver.major
      return false if !ver.minor.nil? && self.minor > ver.minor
      return false if !ver.patch.nil? && self.patch >= ver.patch
      true

    end # <

    def <=(val)

      ver = to_version(val)

      return false if  ver.major.nil? || self.major > ver.major
      return false if !ver.minor.nil? && self.minor > ver.minor
      return false if !ver.patch.nil? && self.patch > ver.patch

      true

    end # <=

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

    def inspect

      _id = '%x' % (self.object_id << 1)

      "#<Anubis::SphinxVersion:0x#{_id}\n" <<
      " major:    #{@major},\n" <<
      " minor:    #{@minor},\n" <<
      " patch:    #{@patch},\n" <<
      " rev:      #{@rev},\n" <<
      "\n" <<
      " dev:      #{@dev},\n" <<
      " beta:     #{@beta},\n" <<
      " release:  #{@release},\n" <<
      " id64:     #{@id64},\n" <<
      "\n" <<
      " bin:      '#{@bin}'>\n"

    end # inspect

    private

    def cmd
      `#{@bin} --help`.chomp
    end # cmd

    def parse(ver, reg)

      resource  = ver.match(reg)

      @major    = resource[1].to_i rescue nil
      @minor    = resource[2].to_i rescue nil
      @patch    = resource[3].to_i rescue nil
      @rev      = resource[5]
      @version  = [@major, @minor, @patch].join(".")

      mt        = resource[4] || ""
      @dev      = mt.include?( "dev".freeze )
      @id64     = mt.include?( "id64".freeze )
      @beta     = mt.include?( "beta".freeze )
      @release  = mt.include?( "release".freeze )

    end # parse

    def to_version(val)

      return val if val.instance_of?(::Anubis::SphinxVersion)

      cache = self.class.cache_versions
      ver   = cache[val]
      return ver unless ver.nil?

      ver   = ::Anubis::SphinxVersion.new(val)
      cache[val] = ver
      ver

    end # to_version

  end # SphinxVersion

end # Anubis
