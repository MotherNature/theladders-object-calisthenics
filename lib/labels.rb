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
  def build_jobtype(jobtype_string)
    case jobtype_string
    when "ATS"
      JobTypeATS.new
    when "JReq"
      JobTypeJReq.new
    end
  end
end
