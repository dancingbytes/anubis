# encoding: utf-8
module Anubis

  class Index

    def initialize(name)

      @params = { "type" => "rt" }

      # default params
      path  ::File.join(::Anubis.root, "db", "anubis", "data", name)
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
        ::Anubis.mkdir(path)
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

      if ::Anubis::sphinx_version.major == 1 ||
         (::Anubis::sphinx_version.major == 2 &&
          ::Anubis::sphinx_version.minor < 2)

        if ["sbcs", "utf-8"].include?(val)
          @params["charset_type"] = val
        end

      end # if

    end # charset_type

    def charset_table(table = nil)

      @params["charset_table"] = table || \
      "U+FF10..U+FF19->0..9, U+FF21..U+FF3A->a..z, U+FF41..U+FF5A->a..z, 0..9, A..Z->a..z, a..z, \
      U+0400->U+0435, U+0401->U+0435, U+0402->U+0452, U+0452, U+0403->U+0433, U+0404->U+0454, \
      U+0454, U+0405->U+0455, U+0455, U+0406->U+0456, U+0407->U+0456, U+0457->U+0456, U+0456, \
      U+0408..U+040B->U+0458..U+045B, U+0458..U+045B, U+040C->U+043A, U+040D->U+0438, U+040E->U+0443, \
      U+040F->U+045F, U+045F, U+0450->U+0435, U+0451->U+0435, U+0453->U+0433, U+045C->U+043A, \
      U+045D->U+0438, U+045E->U+0443, U+0460->U+0461, U+0461, U+0462->U+0463, U+0463, U+0464->U+0465, \
      U+0465, U+0466->U+0467, U+0467, U+0468->U+0469, U+0469, U+046A->U+046B, U+046B, U+046C->U+046D, \
      U+046D, U+046E->U+046F, U+046F, U+0470->U+0471, U+0471, U+0472->U+0473, U+0473, U+0474->U+0475, \
      U+0476->U+0475, U+0477->U+0475, U+0475, U+0478->U+0479, U+0479, U+047A->U+047B, U+047B, U+047C->U+047D, \
      U+047D, U+047E->U+047F, U+047F, U+0480->U+0481, U+0481, U+048A->U+0438, U+048B->U+0438, U+048C->U+044C, \
      U+048D->U+044C, U+048E->U+0440, U+048F->U+0440, U+0490->U+0433, U+0491->U+0433, U+0490->U+0433, \
      U+0491->U+0433, U+0492->U+0433, U+0493->U+0433, U+0494->U+0433, U+0495->U+0433, U+0496->U+0436, \
      U+0497->U+0436, U+0498->U+0437, U+0499->U+0437, U+049A->U+043A, U+049B->U+043A, U+049C->U+043A, \
      U+049D->U+043A, U+049E->U+043A, U+049F->U+043A, U+04A0->U+043A, U+04A1->U+043A, U+04A2->U+043D, \
      U+04A3->U+043D, U+04A4->U+043D, U+04A5->U+043D, U+04A6->U+043F, U+04A7->U+043F, U+04A8->U+04A9, \
      U+04A9, U+04AA->U+0441, U+04AB->U+0441, U+04AC->U+0442, U+04AD->U+0442, U+04AE->U+0443, U+04AF->U+0443, \
      U+04B0->U+0443, U+04B1->U+0443, U+04B2->U+0445, U+04B3->U+0445, U+04B4->U+04B5, U+04B5, U+04B6->U+0447, \
      U+04B7->U+0447, U+04B8->U+0447, U+04B9->U+0447, U+04BA->U+04BB, U+04BB, U+04BC->U+04BD, U+04BE->U+04BD, \
      U+04BF->U+04BD, U+04BD, U+04C0->U+04CF, U+04CF, U+04C1->U+0436, U+04C2->U+0436, U+04C3->U+043A, \
      U+04C4->U+043A, U+04C5->U+043B, U+04C6->U+043B, U+04C7->U+043D, U+04C8->U+043D, U+04C9->U+043D, \
      U+04CA->U+043D, U+04CB->U+0447, U+04CC->U+0447, U+04CD->U+043C, U+04CE->U+043C, U+04D0->U+0430, \
      U+04D1->U+0430, U+04D2->U+0430, U+04D3->U+0430, U+04D4->U+00E6, U+04D5->U+00E6, U+04D6->U+0435, \
      U+04D7->U+0435, U+04D8->U+04D9, U+04DA->U+04D9, U+04DB->U+04D9, U+04D9, U+04DC->U+0436, U+04DD->U+0436, \
      U+04DE->U+0437, U+04DF->U+0437, U+04E0->U+04E1, U+04E1, U+04E2->U+0438, U+04E3->U+0438, U+04E4->U+0438, \
      U+04E5->U+0438, U+04E6->U+043E, U+04E7->U+043E, U+04E8->U+043E, U+04E9->U+043E, U+04EA->U+043E, \
      U+04EB->U+043E, U+04EC->U+044D, U+04ED->U+044D, U+04EE->U+0443, U+04EF->U+0443, U+04F0->U+0443, \
      U+04F1->U+0443, U+04F2->U+0443, U+04F3->U+0443, U+04F4->U+0447, U+04F5->U+0447, U+04F6->U+0433, \
      U+04F7->U+0433, U+04F8->U+044B, U+04F9->U+044B, U+04FA->U+0433, U+04FB->U+0433, U+04FC->U+0445, \
      U+04FD->U+0445, U+04FE->U+0445, U+04FF->U+0445, U+0410..U+0418->U+0430..U+0438, U+0419->U+0438, \
      U+0430..U+0438, U+041A..U+042F->U+043A..U+044F, U+043A..U+044F"

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

      if ::Anubis::sphinx_version.major == 1 ||
         (::Anubis::sphinx_version.major == 2 &&
          ::Anubis::sphinx_version.minor < 2)

        @params["enable_star"] = val ? 1 : 0

      end

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

      if ::Anubis::sphinx_version.major == 1 ||
         (::Anubis::sphinx_version.major == 2 &&
          ::Anubis::sphinx_version.minor < 2)

        @params["ondisk_dict"] = val ? 1 : 0

      end

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
