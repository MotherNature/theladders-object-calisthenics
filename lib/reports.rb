require 'utilities'

module Reports
  def self.included(base_class)
    base_class.extend(ClassMethods)
  end

  module ClassMethods
    def when_reporting(subject, &block)
      define_method(reporting_method_for(subject), &block)
    end

    private

    def reporting_method_for(subject) # TODO: How can I avoid this duplication?
      "report_#{subject}_to".to_sym
    end
  end

  def report_to(reportable)
    relevant_ways_of_reporting_to(reportable).each do |method|
      subject = subject_of_reporting_method(method)

      output = report_output(from: reportable, by_method: reporting_method_for(subject))

      reportable.send(reportables_method_for(subject), output)
    end
  end

  private

  def reporting_method_for(subject) # TODO: How can I avoid this duplication?
    "report_#{subject}_to".to_sym
  end

  def reportables_method_for(subject)
    "report_#{subject}".to_sym
  end

  def report_output(from: nil, by_method: nil)
    self.send(by_method, from)
  end

  def relevant_ways_of_reporting_to(reportable)
    ways_of_reporting.select do |method|
      subject = subject_of_reporting_method(method)
      reportable.respond_to?(reportables_method_for(subject))
    end
  end

  def ways_of_reporting
    methods_used_for_reporting.select do |method|
      ! subject_of_reporting_method(method).nil?
    end
  end
      
  def methods_used_for_reporting
    public_methods.select do |method|
      method.to_s =~ /^report_/
    end
  end
  
  def subject_of_reporting_method(method)
    match = /^report_(.*)_to/.match(method)
    match && match[1]
  end
end

class Report
  def self.reports_on(property_name)
    method_name = "report_#{property_name}".to_sym
    define_method(method_name) do |reporter|
    end
  end

  def self.upon_receiving(property_name, &block)
    method_name = "report_#{property_name}".to_sym
    define_method(method_name, &block)
  end
end
