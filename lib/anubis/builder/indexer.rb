# encoding: utf-8
module Anubis

  class Indexer

    def initialize

      @params = {}

      # defult params
      mem_limit
      max_iops
      max_iosize  1048576

    end # initialize

    def compile
      @params
    end # compile

    def method_missing(name, *args, &block)
    end # method_missing

    private

    def mem_limit(val = "32M")
      @params["mem_limit"] = val
    end # mem_limit

    def max_iops(val = 40)
      @params["max_iops"] = val
    end # max_iops

    def max_iosize(val = 0)
      @params["max_iosize"] = val
    end # max_iosize

    def write_buffer(val = "1M")
      @params["write_buffer"] = val
    end # write_buffer

    def max_file_field_buffer(val = "128M")
      @params["max_file_field_buffer"] = val
    end # max_file_field_buffer

    def on_file_field_error(val = "ignore_field")

      if ["ignore_field", "skip_document", "fail_index"].include?(val)
        @params["on_file_field_error"] = val
      end

    end # on_file_field_error

    def lemmatizer_cache(val = "32M")

      if ::Anubis::sphinx_version >= "1.1"
        @params["lemmatizer_cache"] = val
      end

    end # lemmatizer_cache

  end # Indexer

end # Anubis
