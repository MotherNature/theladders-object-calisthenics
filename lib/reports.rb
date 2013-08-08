require 'utilities'

module Reports
  def self.included(base_class)
    base_class.extend(ClassMethods)
  end

  module ClassMethods
    def when_reporting(method_name, &block)
      full_method_symbol = "report_#{method_name}".to_sym
      define_method(full_method_symbol, &block)
    end
  end

  def report(reportable)
    report_methods = public_methods.select do |method_symbol|
      method_symbol.to_s =~ /^report_/
    end

    report_methods.each do |method_symbol|
      method_symbol.to_s =~ /^report_(.*)/
      reporting_on = $1
      
      full_method_symbol = "report_#{reporting_on}".to_sym

      if(reportable.respond_to?(full_method_symbol))
        reportable.send(full_method_symbol, send(method_symbol))
      end
    end
  end
end

