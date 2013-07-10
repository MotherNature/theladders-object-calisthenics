class Name
  def initialize(name_string)
    @name_string = name_string
  end
end

class Title
  def initialize(title_string)
    @title_string = title_string
  end
end

class Type
  def initialize
    @type_string = ""
    @requires_resume = false
  end

  def requires_resume?
    @requires_resume
  end
end

class TypeATS < Type
  def initialize
    @type_string = "ATS"
    @requires_resume = false
  end
end

class TypeJReq < Type
  def initialize
    @type_string = "JReq"
    @requires_resume = true
  end
end

class TypeFactory
  def build_type(type_string)
    case type_string
    when "ATS"
      TypeATS.new
    when "JReq"
      TypeJReq.new
    end
  end
end
