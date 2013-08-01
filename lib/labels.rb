class IDNumber
  def initialize(idnumber_string)
    @idnumber_string = idnumber_string
  end

  def to_s
    @idnumber_string
  end

  def same_id?(other_idnumber)
    self.to_s == other_idnumber.to_s
  end
end

class JobIdentity
  def initialize(title: nil, idnumber: nil)
    @title = title
    @idnumber = idnumber
  end

  def title_to_string
    @title.to_string
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_job_title))
      displayable.display_job_title(@title)
    end
  end
end

class Name
  def initialize(name_string)
    @name_string = name_string
  end

  def to_s
    @name_string
  end

  def to_string
    to_s
  end

  def same_name?(other_name)
    self.to_s == other_name.to_s
  end

  def display_on(displayable)
    displayable.display_name(@name_string)
  end
end

class Title
  def initialize(title_string)
    @title_string = title_string
  end

  def to_string
    @title_string
  end

  def display_on(displayable)
    displayable.display_title(@name_string)
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

  def to_string
    @jobtype_string
  end

  def display_on(displayable)
    if(displayable.respond_to?(:display_job_type))
      displayable.display_job_type(@jobtype_string)
    end
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
