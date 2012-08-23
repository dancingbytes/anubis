# encoding: utf-8
require  'anubis/builder/indexer'
require  'anubis/builder/searchd'
require  'anubis/builder/index'

module Anubis

  class Builder

    class << self

      def conn
        inst.conn
      end # conn

      def compile
        inst.compile
      end # compile

      def db_paths
        inst.db_paths
      end # db_paths

      private

      def inst
        @inst ||= new
      end # inst

    end # class << self

    def initialize

      @indexer  = {}
      @searchd  = {}
      @index    = {}
      @db_paths = {}

      config_file = ::File.join(::Rails.root, "config", "anubis.rb")
      instance_eval(::File.read(config_file), config_file) if ::File.exists?(config_file)

    end # initialize

    def compile

      {
        "indexer" => @indexer,
        "searchd" => @searchd,
        "index"   => @index
      }

    end # compile

    def conn

      {
        :host       => @host,
        :port       => @port,
        :encoding   => "utf8",
        :reconnect  => true,
        :poolsize   => 30
      }

    end # conn

    def method_missing(name, *args, &block)
    end # method_missing

    def db_paths
      @db_paths
    end # dbs

    private

    def indexer(&block)

      r = ::Anubis::Indexer.new
      r.instance_eval &block if block_given?
      @indexer = r.compile

    end # indexer

    def searchd(&block)

      r = ::Anubis::Searchd.new
      r.instance_eval &block if block_given?

      @host = r.host
      @port = r.port
      @searchd = r.compile

    end # searchd

    def index(name = nil, &block)

      return if name.nil? || name.empty?

      r = ::Anubis::Index.new(name)
      r.instance_eval &block if block_given?
      @index[name] = r.compile
      @db_paths[name] = @index[name]["path"] || nil

    end # index

  end # Builder

end # Anubis