# encoding: utf-8
module Anubis

  class Result < Array

    def initialize(datas, params = {})

      self.count         = params[:total]
      self.current_page  = params[:page]
      self.limit_value   = params[:per_page]
      
      if datas.is_a?(Array)
        datas.flatten!
        self.concat(datas)
      else
        self.concat(datas)
      end
      
    end # initialize  

    def count
      @count || 0
    end # count

    def count=(val)
      @count = val.to_s.to_i(10).abs
    end # count

    def current_page
      @page || 1
    end # current_page

    def current_page=(v)
      @page = v.to_s.to_i(10).abs
    end # current_page  
    
    def num_pages

      return 0 if self.limit_value == 0
      (self.count.to_f / self.limit_value).round

    end # num_pages

    def limit_value
      @per_page || 0
    end # limit_value

    def limit_value=(v)
      @per_page = v.to_s.to_i(10).abs
    end # limit_value  


    alias :current_page_count   :count
    alias :total_found          :count
    alias :total_found=         :count=

    alias :page                 :current_page         

    alias :pages                :num_pages

    alias :per_page             :limit_value
    alias :per_page=            :limit_value=
    
  end # Criteria

end # Anubis