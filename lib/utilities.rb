module RoleTaker # Rename to TakesRoles
  def take_on_role(role_module)
    extend role_module
  end
end

module HumanReadableDelegation
  def self.included(mod)
    mod.class_eval do
      alias_method :redirectee, :__getobj__
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

  def report_to(reportable)
    self.each do |item|
      item.report_to(reportable)
    end
  end

  def filtered_by(filters)
    filtered_items = @list.select do |item|
      filters.all? do |filter|
        item.passes_filter?(filter)
      end
    end
    self.class.new(filtered_items)
  end

  def include?(item)
    @list.include?(item)
  end
end
