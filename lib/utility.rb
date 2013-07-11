class List
  def initialize(list_items=[])
    @list_items = list_items
  end

  def add(list_item)
    @list_items.push(list_item)
  end

  def include?(list_item)
    @list_items.include?(list_item)
  end

  def each(&each_block)
    @jobapplications.each &each_block
  end

  private
  def items_filtered_for(subject_item, &filter_block)
    filtered_items = @items.select do |list_item|
      filter_block.call(list_item)
    end

    self.class.new(filtered_items)
  end
end

