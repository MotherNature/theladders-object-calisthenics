class List
  def initialize(list_items=[])
    @list_items = list_items
  end

  def include?(list_item)
    @list_items.include?(list_item)
  end

  def each(&each_block)
    @list_items.each &each_block
  end

  def to_array
    @list_items
  end

  def select(&filter_block)
    filtered_items = @list_items.select do |list_item|
      filter_block.call(list_item)
    end

    self.class.new(filtered_items)
  end

  def add(list_item)
    @list_items.push(list_item)
  end
end

module ListOrderedByName
  def to_array
    list_items = super
    list_items.sort_by do |list_item|
      list_item.name_to_string
    end
  end
end
