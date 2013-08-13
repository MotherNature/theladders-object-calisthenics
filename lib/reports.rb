require 'utilities'

module Reports
  def self.included(base_class)
    base_class.extend(ClassMethods)
  end

  module ClassMethods
    def when_reporting(method_name, &block)
      full_method_symbol = "report_#{method_name}_to".to_sym
      define_method(full_method_symbol, &block)
    end
  end

  def report_to(reportable)
    ways_of_reporting.each do |method_symbol|
      reporting_on = subject_of_reporting_method(method_symbol)
      
      full_method_symbol = "report_#{reporting_on}".to_sym
      reporting_method_symbol = "report_#{reporting_on}_to".to_sym

      if(reportable.respond_to?(full_method_symbol))
        reportable.send(full_method_symbol, send(reporting_method_symbol, reportable))
      end
    end
  end

  private

  def ways_of_reporting
    methods_used_for_reporting.select do |method_symbol|
      ! subject_of_reporting_method(method_symbol).nil?
    end
  end
      
  def methods_used_for_reporting
    public_methods.select do |method_symbol|
      method_symbol.to_s =~ /^report_/
    end
  end
  
  def subject_of_reporting_method(method_symbol)
    match = /^report_(.*)_to/.match(method_symbol)
    match && match[1]
  end
end

class Report
  def self.reports_on(property_name)
    method_name = "report_#{property_name}".to_sym
    define_method(method_name) do |reporter|
    end
  end

  def self.when_reporting(property_name, &block)
    method_name = "report_#{property_name}".to_sym
    define_method(method_name, &block)
  end
end
