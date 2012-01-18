# encoding: utf-8
module Anubis

  class Index

    def initialize(name)

      @params = { "type" => "rt" }

      # default params
      path  ::File.join(Rails.root, "db", "anubis", "data", name)
      dict
      charset_type
      morphology
      html_remove_elements
      charset_table
      rt_mem_limit

    end # new

    def compile
      
      @params["rt_field"].uniq!           if @params["rt_field"]
      @params["rt_attr_uint"].uniq!       if @params["rt_attr_uint"]
      @params["rt_attr_bigint"].uniq!     if @params["rt_attr_bigint"]
      @params["rt_attr_float"].uniq!      if @params["rt_attr_float"]
      @params["rt_attr_multi"].uniq!      if @params["rt_attr_multi"]
      @params["rt_attr_multi_64"].uniq!   if @params["rt_attr_multi_64"]
      @params["rt_attr_timestamp"].uniq!  if @params["rt_attr_timestamp"]
      @params["rt_attr_string"].uniq!     if @params["rt_attr_string"]
      @params

    end # compile

    def method_missing(name, *args, &block)
    end # method_missing

    private

    def path(val)

      return unless val
        
      arr = ::File.split(val)
      arr.pop
      if (path = ::File.join(arr))
        Anubis.mkdir(path)
        @params["path"] = val
      end
      
    end # path
    
    def docinfo(val = "extern")

      if ["extern", "none", "extern", "inline"].include?(val)
        @params["docinfo"] = val
      end  

    end # docinfo

    def mlock(val = 0)
      @params["mlock"] = val ? 1 : 0
    end # mlock

    def morphology(val = "stem_en, stem_ru")
      @params["morphology"] = val
    end # morphology  

    def dict(val = "keywords")

      if ["crc", "keywords"].include?(val)
        @params["dict"] = val
      end  

    end # dict

    def index_sp(val = 1)
      @params["index_sp"] = val
    end # index_sp

    def index_zones(val = nil)
      @params["index_zones"] = val || ""
    end # index_zones

    def min_stemming_len(val = 1)
      @params["min_stemming_len"] = val
    end # min_stemming_len  

    def stopwords(val = nil)
      @params["stopwords"] = val || ""
    end # stopwords

    def wordforms(val = nil)
      @params["wordforms"] = val || ""
    end # wordforms  

    def exceptions(val = nil)
      @params["exceptions"] = val || ""
    end # exceptions  

    def min_word_len(val = 1)
      @params["min_word_len"] = val
    end # min_word_len  

    def charset_type(val = "utf-8") # sbcs

      if ["sbcs", "utf-8"].include?(val)
        @params["charset_type"] = val
      end
        
    end # charset_type

    def charset_table(table = nil)

      @params["charset_table"] = table || \
      "0..9, A..Z->a..z, a..z, U+410..U+42F->U+430..U+44F, U+430..U+44F,U+C5->U+E5, U+E5, \
      U+C4->U+E4, U+E4, U+D6->U+F6, U+F6, U+16B, U+0c1->a, U+0c4->a, U+0c9->e, U+0cd->i, \
      U+0d3->o, U+0d4->o, U+0da->u, U+0dd->y, U+0e1->a, U+0e4->a, U+0e9->e, U+0ed->i, U+0f3->o, \
      U+0f4->o, U+0fa->u, U+0fd->y, U+104->U+105, U+105, U+106->U+107, U+10c->c, U+10d->c, \
      U+10e->d, U+10f->d, U+116->U+117, U+117, U+118->U+119, U+11a->e, U+11b->e, U+12E->U+12F, \
      U+12F, U+139->l, U+13a->l, U+13d->l, U+13e->l, U+141->U+142, U+142, U+143->U+144, U+144, \
      U+147->n, U+148->n, U+154->r, U+155->r, U+158->r, U+159->r, U+15A->U+15B, U+15B, U+160->s, \
      U+160->U+161, U+161->s, U+164->t, U+165->t, U+16A->U+16B, U+16B, U+16e->u, U+16f->u, \
      U+17B->U+17C, U+17C, U+17d->z, U+17e->z"

    end # charset_table

    def ignore_chars(val = nil)
      @params["ignore_chars"] = val || ""
    end # ignore_chars

    def min_prefix_len(val = 0)
      @params["min_prefix_len"] = val
    end # min_prefix_len  

    def min_infix_len(val = 0)
      @params["min_infix_len"] = val
    end # min_infix_len

    def prefix_fields(val = nil)
      @params["prefix_fields"] = val || ""
    end # prefix_fields  

    def infix_fields(val = nil)
      @params["infix_fields"] = val || ""
    end # infix_fields  

    def enable_star(val = 0)
      @params["enable_star"] = val ? 1 : 0
    end # enable_star  

    def ngram_len(val = 0)
      @params["ngram_len"] = val
    end # ngram_len

    def ngram_chars(table = nil)
      @params["ngram_chars"] = table || ""
    end # ngram_chars  

    def phrase_boundary(val = nil)
      @params["phrase_boundary"] = val || ""
    end # phrase_boundary  

    def phrase_boundary_step(val = 0)
      @params["phrase_boundary_step"] = val
    end # phrase_boundary_step  

    def html_strip(val = 1)
      @params["html_strip"] = val ? 1 : 0
    end # html_strip

    def html_index_attrs(val = nil)
      @params["html_index_attrs"] = val || ""
    end # html_index_attrs

    def html_remove_elements(val = "style, script")
      @params["html_remove_elements"] = val || ""
    end # html_remove_elements

    def local(val = nil)
      @params["local"] = val || ""
    end # local

    def agent(val = nil)
      @params["agent"] = val || ""
    end # agent  

    def agent_blackhole(val = nil)
      @params["agent_blackhole"] = val || ""
    end # agent_blackhole

    def agent_connect_timeout(val = 1000)
      @params["agent_connect_timeout"] = val
    end # agent_connect_timeout  

    def agent_query_timeout(val = 3000)
      @params["agent_query_timeout"] = val
    end # agent_query_timeout  

    def preopen(val = 1) # 0
      @params["preopen"] = val ? 1 : 0
    end # preopen  

    def ondisk_dict(val = 0)
      @params["ondisk_dict"] = val ? 1 : 0
    end # ondisk_dict

    def inplace_enable(val = 0)
      @params["inplace_enable"] = val ? 1 : 0
    end # inplace_enable  

    def inplace_hit_gap(val = 0)
      @params["inplace_hit_gap"] = val
    end # inplace_hit_gap

    def inplace_docinfo_gap(val = 0)
      @params["inplace_docinfo_gap"] = val
    end # inplace_docinfo_gap

    def inplace_reloc_factor(val = 0.1)
      @params["inplace_reloc_factor"] = val
    end # inplace_reloc_factor  

    def inplace_write_factor(val = 0.1)
      @params["inplace_write_factor"] = val
    end # inplace_write_factor  

    def index_exact_words(val = 0)
      @params["index_exact_words"] = val ? 1 : 0
    end # index_exact_words

    def overshort_step(val = 1)
      @params["overshort_step"] = val ? 1 : 0
    end # overshort_step

    def stopword_step(val = 1)
      @params["stopword_step"] = val ? 1 : 0
    end # stopword_step

    def hitless_words(val = "all")
      @params["hitless_words"] = val
    end # hitless_words  

    def expand_keywords(val = 0)
      @params["expand_keywords"] = val ? 1 : 0
    end # expand_keywords  

    def blend_chars(val = nil)
      @params["blend_chars"] = val || ""
    end # blend_chars

    def blend_mode(val = "trim_none")
      @params["blend_mode"] = val
    end # blend_mode

    def rt_mem_limit(val = "128M")
      @params["rt_mem_limit"] = val || ""
    end # rt_mem_limit  

    def rt_field(val)
      (@params["rt_field"] ||= []) << val if val
    end # rt_field

    def rt_attr_uint(val)
      (@params["rt_attr_uint"] ||= []) << val if val
    end # rt_attr_uint

    def rt_attr_bigint(val)
      (@params["rt_attr_bigint"] ||= []) << val if val
    end # rt_attr_bigint

    def rt_attr_float(val)
      (@params["rt_attr_float"] ||= []) << val if val
    end # rt_attr_float

    def rt_attr_multi(val)
      (@params["rt_attr_multi"] ||= []) << val if val
    end # rt_attr_multi  

    def rt_attr_multi_64(val)
      (@params["rt_attr_multi_64"] ||= []) << val if val
    end # rt_attr_multi_64  

    def rt_attr_timestamp(val)
      (@params["rt_attr_timestamp"] ||= []) << val if val
    end # rt_attr_timestamp

    def rt_attr_string(val)
      (@params["rt_attr_string"] ||= []) << val if val
    end # rt_attr_string  

  end # Index

end # Anubis