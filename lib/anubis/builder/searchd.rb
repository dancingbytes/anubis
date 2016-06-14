# encoding: utf-8
module Anubis

  class Searchd

    def initialize

      @params = {}

      # default params
      log         ::File.join(::Anubis.root, "log",   "sphinx.log")
      query_log   ::File.join(::Anubis.root, "log",   "sphinx.query.log")
      pid_file    ::File.join(::Anubis.root, "pids",  "sphinx.pid")
      binlog_path ::File.join(::Anubis.root, "binlog")

      compat_sphinxql_magics
      query_log_format
      workers

    end # initialize

    def compile
      @params
    end # compile

    def host
      @host || "127.0.0.1"
    end # host

    def port
      (@port || 9306).to_i
    end # port

    def method_missing(name, *args, &block)
    end # method_missing

    private

    def listen(val)

      #
      # localhost
      # 192.168.0.1
      # localhost:5000
      # 192.168.0.1:5000
      # 9312
      # localhost:9306:mysql41
      # 192.168.0.1:5000:mysql41
      #
      re = /\A(?<ip>\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}|localhost)(:(?<port>(\d+))){0,1}(:mysql41){0,1}\Z|\A(?<port2>\d+)\Z/

      if r = (@params["listen"] = val || "").match(re)
        @host = r["ip"]
        @port = r["port"] || r["port2"]
      end

    end # listen

    def log(val = nil)

      return unless val
      ::Anubis.mkdir(::File.dirname(val))
      @params["log"] = val

    end # log

    def query_log(val = nil)

      return unless val
      ::Anubis.mkdir(::File.dirname(val))
      @params["query_log"] = val

    end # query_log

    def query_log_format(val = "sphinxql")

      if ["plain", "sphinxql"].include?(val)
        @params["query_log_format"] = val
      end

    end # query_log_format

    def read_timeout(val = 5)
      @params["read_timeout"] = val
    end # read_timeout

    def client_timeout(val = 300)
      @params["client_timeout"] = val
    end # client_timeout

    def max_children(val = 0)
      @params["max_children"] = val
    end # max_children

    def pid_file(val)

      return unless val
      ::Anubis.mkdir(::File.dirname(val))
      @params["pid_file"] = val

    end # pid_file

    def max_matches(val = 1000)

      if ::Anubis::sphinx_version <= "2.2.2"
        @params["max_matches"] = val
      end

    end # max_matches

    def seamless_rotate(val = 1)
      @params["seamless_rotate"] = val
    end # seamless_rotate

    def preopen_indexes(val = 1)
      @params["preopen_indexes"] = val
    end # preopen_indexes

    def unlink_old(val = 1)
      @params["unlink_old"] = val
    end # unlink_old

    def attr_flush_period(val = 0)
      @params["attr_flush_period"] = val
    end # attr_flush_period

    def ondisk_dict_default(val = 0)

      if ::Anubis::sphinx_version < "2.2"
        @params["ondisk_dict_default"] = val
      end

    end # ondisk_dict_default

    def max_packet_size(val = "8M")
      @params["max_packet_size"] = val
    end # max_packet_size

    def mva_updates_pool(val = "1M")
      @params["mva_updates_pool"] = val
    end # mva_updates_pool

    def max_filters(val = 256)
      @params["max_filters"] = val
    end # max_filters

    def max_filter_values(val = 4096)
      @params["max_filter_values"] = val
    end # max_filter_values

    def listen_backlog(val = 5)
      @params["listen_backlog"] = val
    end # listen_backlog

    def read_buffer(val = "256K")
      @params["read_buffer"] = val
    end # read_buffer

    def read_unhinted(val = "32K")
      @params["read_unhinted"] = val
    end # read_unhinted

    def max_batch_queries(val = 32)
      @params["max_batch_queries"] = val
    end # max_batch_queries

    def subtree_docs_cache(val = "8M") # 0
      @params["subtree_docs_cache"] = val
    end # subtree_docs_cache

    def subtree_hits_cache(val = "16M") # 0
      @params["subtree_hits_cache"] = val
    end # subtree_hits_cache

    def workers(val = "threads")
      @params["workers"] = val
    end # workers

    def dist_threads(val = nil)
      @params["dist_threads"] = val unless val
    end # dist_threads

    def binlog_path(val)

      ::Anubis.mkdir(val) if val
      @params["binlog_path"] = val || ""

    end # binlog_path

    def binlog_flush(val = 2)

      if [0, 1, 2].include?(val)
        @params["binlog_flush"] = val
      end

    end # binlog_flush

    def binlog_max_log_size(val = "16M") # 0
      @params["binlog_max_log_size"] = val
    end # binlog_max_log_size

    def collation_server(val = "libc_ci")
      @params["collation_server"] = val # utf8_ci
    end # collation_server

    def collation_libc_locale(val = "C")
      @params["collation_libc_locale"] = val # ru_RU
    end # collation_libc_locale

    def plugin_dir(val = nil)
      @params["plugin_dir"] = (val && ::FileTest.directory?(val) ? val : "")
    end # plugin_dir

    def mysql_version_string(val = nil)
      @params["mysql_version_string"] = val || ""
    end # mysql_version_string

    def rt_flush_period(val = 0)
      @params["rt_flush_period"] = val
    end # rt_flush_period

    def thread_stack(val = "64K")
      @params["thread_stack"] = val
    end # thread_stack

    def expansion_limit(val = 0)
      @params["expansion_limit"] = val
    end # expansion_limit

    def compat_sphinxql_magics(val = 0)

      if ::Anubis::sphinx_version < "2.2"
        @params["compat_sphinxql_magics"] = val
      end

    end # compat_sphinxql_magics

    def watchdog(val = 1)
      @params["watchdog"] = val ? 1 : 0
    end # watchdog

    def prefork_rotation_throttle(val = 0)

      if ::Anubis::sphinx_version < "2.3.1"
        @params["prefork_rotation_throttle"] = val
      end

    end # prefork_rotation_throttle

  end # Searchd

end # Anubis
