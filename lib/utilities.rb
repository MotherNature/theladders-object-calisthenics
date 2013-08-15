module TakesRoles # Rename to TakesRoles
  def take_on_role(role_module) # TODO: Remove once we've made all roles into delegators
    extend role_module
  end

  def with_role(role)
    role.delegate_to(self)
  end
end

module Filterable
  def self.included(base_class)
    base_class.extend(ClassMethods)
  end

  module ClassMethods
    def when_filtering_by(method_name, &block)
      full_method_symbol = "filter_by_#{method_name}".to_sym
      define_method(full_method_symbol, &block)
    end
  end

  def passes_filters?(filters)
    answers = filters.map do |filter|
      self.passes_filter?(filter)
    end
    answers.all?
  end

  def passes_filter?(filter)
    implemented_methods = methods_implemented_for(filter: filter, among_methods: filter_methods)

    pass_checks = implemented_methods.map do |method_symbol|
      filter.send(method_symbol, send(method_symbol, filter))
    end
    
    fails_no_tests(pass_checks)
  end

  private

  def methods_implemented_for(filter: nil, among_methods: [])
    among_methods.select do |method_symbol|
      filter.respond_to?(method_symbol)
    end
  end

  def filter_methods
    public_methods.select do |method_symbol|
      method_symbol.to_s =~ /^filter_by_/
    end
  end

  def fails_no_tests(answers)
    answers.none? do |passed|
      passed == false
    end
  end
end

module HumanReadableDelegation
  def self.included(mod)
    mod.class_eval do
      alias_method :delegatee, :__getobj__
      alias_method :delegatee=, :__setobj__
    end
  end
end

class List
  def initialize(list=[])
    @list = list
  end

  def each(&block)
    @list.each(&block)
  end

  def select(&block)
    filtered_items = @list.select(&block)
    self.class.new(filtered_items)
  end

  def size
    @list.size
  end

  def with(new_item)
    self.class.new([*@list, new_item])
  end

  def any?(&block)
    filtered_list = select(&block)
    filtered_list.size > 0
  end

  def map(&block)
    @list.map(&block)
  end

  def report_to(reportable)
    self.each do |item|
      item.report_to(reportable)
    end
  end

  def filtered_by(filters)
    filtered_items = @list.select do |item|
      item.passes_filters?(filters)
    end
    self.class.new(filtered_items)
  end

  def include?(item)
    @list.include?(item)
  end
end
