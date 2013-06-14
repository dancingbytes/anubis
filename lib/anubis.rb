# encoding: utf-8
require  'anubis/protocol'
require  'anubis/version'

require  'anubis/builder'
require  'anubis/functions/snippets'

require  'anubis/ext/mongoid'   if defined?(::Mongoid)

require  'anubis/result'
require  'anubis/railtie'       if defined?(::Rails)

module Anubis

  extend self

  def root

    unless @root
      @root = ::Rails.root if defined?(::Rails)
    end
    @root

  end # root

  def logger(msg)

    unless @logger
      @logger = ::Rails.logger if defined?(::Rails)
    end
    @logger.error(msg)

  end # logger

  def mkdir(val)
    ::FileUtils.mkdir_p(val, :mode => 0755) unless ::FileTest.directory?(val)
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

  def escape(str, escape_fields = true)

    str = (str || "")
      .gsub(/[\n\r]/, " ")
      .gsub('/', '\/')
      .gsub('-', '\\-')
      .gsub('(', '\\(')
      .gsub(')', '\\)')

    str = str.gsub('@', '\\@') if escape_fields

    conn.escape(str)

  end # escape

  def simple_escape(str)
    conn.escape(str)
  end # simple_escape

  def sql(q)

    retry_stop = false

    begin
      conn.query(q)
    rescue => e

      e = ::Anubis::SphinxError.new(e)
      if !retry_stop && (
          !(e.error =~ ::Regexp.new("Can't connect to Sphinx server on")).nil? ||
          !(e.error =~ ::Regexp.new("Lost connection to MySQL server during query")).nil?
        )

        retry_stop = true
        sphinx_connect
        sleep 3
        retry

      end

      puts "[request] #{q}"
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
    msg `searchd -c #{sphinx_conf}`, $?, "Ok"

  end # start

  def stop

    return unless config_exists?
    msg `searchd -c #{sphinx_conf} --stop`, $?, "Ok"

  end # stop

  def stopwait

    return unless config_exists?
    msg `searchd -c #{sphinx_conf} --stopwait`, $?, "Ok"

  end # stopwait

  def sphinx_conf
    @sphinx_conf ||= ::File.join(::Anubis.root, "config", "sphinx.conf")
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
      msg `rm -rf #{path}.*`, $?, "Ok"
    end
    self

  end # drop

  def drop_all

    ::Anubis::Builder.db_paths.each_key do |key|
      self.drop(key)
    end
    self

  end # drop_all

  private

  def manage_index(name)

    unless (path = ::Anubis::Builder.db_paths[name])
      puts ::Anubis.logger("ANUBIS [ERROR] Sphinx index `#{name}` is not found.")
    else
      yield(path)
    end # unless

  end # manage_index

  def msg(result, answer, message = nil)
    puts (answer.exitstatus == 0 ? (message || result) : ::Rails.logger.error(result))
  end # msg

  def config_exists?

    unless ::File.exist?(sphinx_conf)
      puts ::Anubis.logger("ANUBIS [ERROR] Configuration file #{sphinx_conf} does not exist. Please, generate it before.")
      return false
    else
      return true
    end

  end # config_exists?

  def conn

    sphinx_connect if (::Thread.current[:conn].nil? || !::Thread.current[:conn].ping)
    ::Thread.current[:conn]

  end # conn

  def sphinx_connect

    retry_stop = false

    begin
      ::Thread.current[:conn] = ::Anubis::Protocol.connection(::Anubis::Builder.conn)
    rescue => e

      e = ::Anubis::SphinxError.new(e)
      if !retry_stop &&
        (
          !(e.error =~ ::Regexp.new("Can't connect to Sphinx server on")).nil? ||
          !(e.error =~ ::Regexp.new("Lost connection to MySQL server during query")).nil?
        )
        retry_stop = true
        start
        sleep 3
        retry
      end

      raise e

    end

  end # sphinx_connect

end # Anubis
