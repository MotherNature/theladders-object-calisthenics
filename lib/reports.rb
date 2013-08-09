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
    report_methods = public_methods.select do |method_symbol|
      method_symbol.to_s =~ /^report_/
    end

    report_methods.each do |method_symbol|
      method_symbol.to_s =~ /^report_(.*)_to/
      reporting_on = $1
      
      full_method_symbol = "report_#{reporting_on}".to_sym
      reporting_method_symbol = "report_#{reporting_on}_to".to_sym

      if(reportable.respond_to?(full_method_symbol))
        reportable.send(full_method_symbol, send(reporting_method_symbol, reportable))
      end
    end
  end
end

class Report
  def self.report_on(property_name)
    method_name = "report_#{property_name}".to_sym
    define_method(method_name) do |reporter|
    end
  end
end
