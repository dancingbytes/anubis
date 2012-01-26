# encoding: utf-8
module Anubis

  class Snippets < ::BasicObject

    HTML_STRIP_MODE_VALUES = [
      "index", "none", "strip", "retain"
    ]

    PASSAGE_BOUNDARY_VALUES = [
      "sentence", "paragraph", "zone"
    ]

    def initialize(conn, data, index, query)
      
      @conn     = conn
      @options  = {}
      @index    = index
      @query    = query
      @sql      = nil

      @data = data.is_a?(::Array) ? data : [data]
      @data = @data.map! { |v| "'#{conn.escape(v)}'" }.join(",")

    end # new

    def before_match(val = "<b>")
      
      manage_option("before_match", val) do |v|
        "'#{@conn.escape(v)}'"
      end
      
    end # before_match

    def after_match(val = "</b>")
      
      manage_option("after_match", val) do |v|
        "'#{@conn.escape(v)}'"
      end
      
    end # after_match      

    def chunk_separator(val = "...")
      
      manage_option("chunk_separator", val) { |v|
        "'#{@conn.escape(v)}'"
      }
      
    end # chunk_separator
    
    def limit(val = 256)
      
      manage_option("limit", val) { |v|
        v.to_s.to_i(10).abs
      }

    end # limit

    def around(val = 5)
      
      manage_option("around", val) { |v|
        v.to_s.to_i(10).abs
      }

    end # around  

    def exact_phrase(val = false)

      manage_option("exact_phrase", val) { |v|
        (v == true ? 1 : 0)
      }

    end # exact_phrase  

    def single_passage(val = false)

      manage_option("single_passage", val) { |v|
        (v == true ? 1 : 0)
      }

    end # single_passage  

    def use_boundaries(val = false)

      manage_option("use_boundaries", val) { |v|
        (v == true ? 1 : 0)
      }

    end # use_boundaries  

    def weight_order(val = false)

      manage_option("weight_order", val) { |v|
        (v == true ? 1 : 0)
      }

    end # weight_order  

    def query_mode(val = false)

      manage_option("query_mode", val) { |v|
        (v == true ? 1 : 0)
      }

    end # query_mode  

    def force_all_words(val = false)

      manage_option("force_all_words", val) { |v|
        (v == true ? 1 : 0)
      }

    end # force_all_words  

    def limit_passages(val = 0)

      manage_option("limit_passages", val) { |v|
        v.to_s.to_i(10).abs
      }

    end # limit_passages  

    def limit_words(val = 0)

      manage_option("limit_words", val) { |v|
        v.to_s.to_i(10).abs
      }

    end # limit_words  

    def start_passage_id(val = 1)
      
      manage_option("start_passage_id", val) { |v|
        v.to_s.to_i(10).abs
      }

    end # start_passage_id  

    def load_files(val = false)
      
      manage_option("load_files", val) { |v|
        (v == true ? 1 : 0)
      }

    end # load_files  

    def load_files_scattered(val = false)

      manage_option("load_files_scattered", val) { |v|
        (v == true ? 1 : 0)
      }

    end # load_files_scattered  

    def html_strip_mode(val = "index")
      
      manage_option("html_strip_mode", val) { |v|
        v = v.to_s.downcase
        v = HTML_STRIP_MODE_VALUES.first unless HTML_STRIP_MODE_VALUES.include?(v)
        "'#{@conn.escape(v)}'"
      }
      self

    end # html_strip_mode  

    def allow_empty(val = false)

      manage_option("allow_empty", val) { |v|
        (v == true ? 1 : 0)
      }
      self

    end # allow_empty  

    def passage_boundary(val = nil)

      manage_option("passage_boundary", val) { |v|
        v = v.to_s.downcase
        v = PASSAGE_BOUNDARY_VALUES.first unless PASSAGE_BOUNDARY_VALUES.include?(v)
        "'#{@conn.escape(v)}'"
      }
      self

    end # passage_boundary  

    def emit_zones(val = false)
      
      manage_option("emit_zones", val) { |v|
        (v == true ? 1 : 0)
      }
      self

    end # emit_zones  

    def to_sql

      unless @sql
        options = ", " << @options.values.join(', ') unless @options.empty?
        @sql = "CALL SNIPPETS((#{@data}), '#{@index}', '#{@query}'#{options})"
      end
      @sql

    end # to_sql  

    def method_missing(name, *args, &block)

      s = @conn.sql(self.to_sql)
      s.send(name, *args, &block)

    end # method_missing

    def inspect

      "#<Anubis::Snippets\n" <<
      " data:     #{@data},\n" <<
      " index:    #{@index},\n" <<
      " query:    #{@query},\n" <<
      " options:  #{@options.inspect}>\n"

    end # inspect

    private

    def manage_option(key, value)

      @sql = nil
      if value.nil?
        @options.delete(key)
      else
        value = yield(value)
        @options[key] = "#{value} AS #{key}"  
      end
      self

    end # manage_option

  end # Snippets

end # Anubis