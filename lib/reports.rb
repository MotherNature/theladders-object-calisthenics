module GeneratesReportsOfNames
  def to_string
    puts "Got here?"
    name_strings = @list.to_array.map do |list_item|
      list_item.name_to_string
    end
    name_strings.join("\n")
  end
end

class ListReport
  def initialize(list)
    @list = list
  end

  def to_string
    ""
  end
end

class ListReportGenerator
  def generate_from(list)
    ListReport.new(list)
  end
end
