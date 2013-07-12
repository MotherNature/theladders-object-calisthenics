class ListReport
  def initialize(list)
    @list = list
  end

  def to_string
    name_strings = @list.to_array.map do |list_item|
      list_item.name_to_string
    end
    name_strings.join("\n")
  end
end

class ListReportGenerator
  def generate_from(list)
    listreport = ListReport.new(list)
  end
end
