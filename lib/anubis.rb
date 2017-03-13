# encoding: utf-8
require  'anubis/sphinx/core'
require  'anubis/sphinx/version'

require  'anubis/protocol'
require  'anubis/version'

require  'anubis/builder'
require  'anubis/functions/snippets'

require  'anubis/ext/mongoid'   if defined?(::Mongoid)

require  'anubis/result'
require  'anubis/railtie'       if defined?(::Rails)
require  'thread'

module Anubis

  extend self

  def root(val = nil)

    @root   = val unless val.nil?
    @root ||= File.join(::Rails.root, 'anubis') if defined?(::Rails)
    @root ||= File.join(::Dir.pwd,    'anubis')

    mkdir(@root)

  end # root

  def logger(msg)

    if defined?(::Rails)
      @logger ||= ::Rails.logger if defined?(::Rails)
      @logger.error(msg)
    else
      puts msg
    end

  end # logger

  def mkdir(val)

    ::FileUtils.mkdir_p(val, mode: 0755) unless ::FileTest.directory?(val)
    val

  end # mkdir

  def meta

    req = {}
    sql("show meta").each do |result|
      req[ result["Variable_name"] ] = result["Value"]
    end
    req

  end # meta

  def snippets(data, index, query)
    ::Anubis::Snippets.new(self, data, index, query)
  end # snippets

  def escape(s, escape_fields = true)

    return s unless s.is_a?(String)

    str = s.gsub(/[\n\r]/, " ")

    str.gsub!('"', '\"')
    str.gsub!('/', '\/')
    str.gsub!('(', '\\(')
    str.gsub!(')', '\\)')
    str.gsub!(/\s{1,}\-/, '\\-')

    if escape_fields
      str.gsub!('|', '\\|')
      str.gsub!('@', '\\@')
    end

    conn.escape(str)

  end # escape

  def simple_escape(str)
    conn.escape(str)
  end # simple_escape

  def escape2(s, escape_fields = true)

    return s unless s.is_a?(String)

    str = ::Regexp.escape(s)
    str.gsub!(/[\(\)!~"\/]/) { |match| "\\\\#{match}" }
    str.gsub!('\r', '')
    str.gsub!('\n', '')
    str.gsub!('\t', '')
    str.gsub!('|', '\|')

    str.gsub!(/-/) { |match| "\\#{match}" }
    str.gsub!(/'/) { |match| "\\#{match}" }
    str.gsub!(/@/) { |match| "\\\\#{match}" } if escape_fields

    str

  end # escape2

  def sql(q)

    retry_stop = false

    begin
      conn.query(q, { cast: false, cast_booleans: false, symbolize_keys: false })
    rescue => e

      e = ::Anubis::SphinxError.new(e)
      if !retry_stop && (
          !(e.error =~ ::Regexp.new("Can't connect to Sphinx server on")).nil? ||
          !(e.error =~ ::Regexp.new("Lost connection to MySQL server during query")).nil?
        )

        retry_stop = true
        sphinx_connect
        retry

      end

      ::Anubis.logger("[request] #{q}")
      raise ::Anubis::SphinxError.new(e)

    end

  end # sql

  def configure

    conf = ::Anubis::Builder.compile

    str = ""

    str << "indexer {\n"
    conf["indexer"].each do |key, value|
      str << "\t#{key} = #{value}\n"
    end
    str << "}\n\r\r"

    str << "searchd {\n"
    conf["searchd"].each do |key, value|
      str << "\t#{key} = #{value}\n"
    end
    str << "}\n\r\r"

    conf["index"].each do |key, items|

      str << "index #{key} {\n"
      items.each do |k, v|

        if v.is_a?(Array)
          v.each { |i| str << "\t#{k} = #{i}\n" }
        else
          str << "\t#{k} = #{v}\n"
        end

      end
      str << "}\n\r"

    end # each

    ::File.open(sphinx_conf, "w") { |f|
      f.write(str)
    }

    ::File.exist?(sphinx_conf)

  end # configure

  def start

    return unless config_exists?
    system_call `#{::Anubis::SphinxCore.searchd} -c #{sphinx_conf}`, "Ok"

  end # start

  def stop

    return unless config_exists?
    system_call `#{::Anubis::SphinxCore.searchd} -c #{sphinx_conf} --stop`, "Ok"

  end # stop

  def stopwait

    return unless config_exists?
    system_call `#{::Anubis::SphinxCore.searchd} -c #{sphinx_conf} --stopwait`, "Ok"

  end # stopwait

  def sphinx_conf

    @sphinx_conf ||= ::File.join(::Anubis.root, "config", "sphinx.conf")
    mkdir(::File.dirname(@sphinx_conf))
    @sphinx_conf

  end # sphinx_conf

  def create(name)

    puts "Create directory for Sphinx index `#{name}`..."
    manage_index(name) do |path|

      arr = ::File.split(path)
      arr.pop

      if (path = ::File.join(arr))
        ::Anubis.mkdir(path)
        puts "Ok"
      else
        puts "`#{path}` is not a directory."
      end

    end # do
    self

  end # create

  def create_all

    ::Anubis::Builder.db_paths.each_key do |key|
      self.create(key)
    end
    self

  end # create_all

  def drop(name)

    puts "Remove directory for Sphinx index `#{name}`..."
    manage_index(name) do |path|
      system_call `rm -rf #{path}.*`, "Ok"
    end
    self

  end # drop

  def drop_all

    ::Anubis::Builder.db_paths.each_key do |key|
      self.drop(key)
    end
    self

  end # drop_all

  def sphinx_version
    @sphinx_version ||= ::Anubis::SphinxVersion.new
  end # sphinx_version

  private

  def manage_index(name)

    if (path = ::Anubis::Builder.db_paths[name])
      yield(path)
    else
      puts ::Anubis.logger("ANUBIS [ERROR] Sphinx index `#{name}` is not found.")
    end # unless

  end # manage_index

  def system_call(result, message = nil)
    puts ($?.exitstatus == 0 ? (message || result) : ::Anubis.logger(result))
  end # system_call

  def config_exists?

    if ::File.exist?(sphinx_conf)
      true
    else
      puts ::Anubis.logger("ANUBIS [ERROR] Configuration file #{sphinx_conf} does not exist. Please, generate it before.")
      false
    end

  end # config_exists?

  def conn

    sphinx_connect if (::Thread.current[:anubis].nil? || !::Thread.current[:anubis].ping)
    ::Thread.current[:anubis]

  end # conn

  def sphinx_connect

    retry_stop = false

    begin
      ::Thread.current[:anubis] = ::Anubis::Protocol.connection(::Anubis::Builder.conn)
    rescue => e

      e = ::Anubis::SphinxError.new(e)
      if  !retry_stop &&
          !(e.error =~ ::Regexp.new("Lost connection to MySQL server during query")).nil?

        retry_stop = true
        start
        sleep 3
        retry

      end

      raise e

    end

  end # sphinx_connect

end # Anubis
