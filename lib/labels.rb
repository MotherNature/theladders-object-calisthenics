require 'reports'

class Name
  include Reports

  def initialize(name_string)
    @name = name_string
  end

  def as_reportable
    @name
  end

  when_reporting :name do |reportable|
    @name
  end
end

class Title
  include Reports

  def initialize(title_string)
    @title = title_string
  end

  def as_reportable
    @title
  end

  when_reporting :title do |reportable|
    @title
  end
end

class JobType
  class ATS
    def suitable_resume?(resume)
      ! resume.exists?
    end
  end

  class JReq
    def suitable_resume?(resume)
      resume.exists?
    end
  end

  def self.ATS
    ATS.new
  end

  def self.JReq
    JReq.new
  end
end
