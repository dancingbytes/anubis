# encoding: utf-8
module Anubis

  class Criteria < Mongoid::Criteria
    
    def initialize(original_criteria, options = {})
      
      @original_criteria = original_criteria
      @page       = options[:page].try(:to_i) || 1
      @per_page   = options[:per_page].try(:to_i) || 20
      @total      = options[:total].try(:to_i) || @original_criteria.count
      @options    = @original_criteria.options 
      @klass      = @original_criteria.klass 
      @documents  = @original_criteria.documents
      @embedded   = @original_criteria.embedded
      @selector   = @original_criteria.selector
      
    end # new
    
    def current_page
      @page
    end # current_page
    
    def num_pages
      (@total.to_f / @per_page).round
    end # num_pages
    
    def limit_value
      @per_page
    end # limit_value
    
    def total_found
      @total
    end # total_found
    
  end # Criteria

end # Anubis  