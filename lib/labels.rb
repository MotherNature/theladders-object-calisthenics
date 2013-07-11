class IDNumber
  def initialize(idnumber_string)
    @idnumber_string = idnumber_string
  end

  def to_s
    @idnumber_string
  end
end

class Identity
  def initialize(name: nil, idnumber: nil)
    @name = name
    @idnumber = idnumber
  end

  def to_s
    "Name: #{@name}\nID Number: #{@idnumber}"
  end
end

class Name
  def initialize(name_string)
    @name_string = name_string
  end

  def to_s
    @name_string
  end
end

class Title
  def initialize(title_string)
    @title_string = title_string
  end
end

class JobType
  def initialize
    @jobtype_string = ""
    @requires_resume = false
  end

  def requires_resume?
    @requires_resume
  end
end

class JobTypeATS < JobType
  def initialize
    @jobtype_string = "ATS"
    @requires_resume = false
  end
end

class JobTypeJReq < JobType
  def initialize
    @jobtype_string = "JReq"
    @requires_resume = true
  end
end

class JobTypeFactory
  def initialize
    @string_class_pairings = {
      "ATS" => JobTypeATS.new,
      "JReq" => JobTypeJReq.new
    }
  end

  def build_jobtype(jobtype_string)
    @string_class_pairings[jobtype_string]
  end
end
