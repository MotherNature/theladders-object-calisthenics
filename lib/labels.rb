require 'reports'

class Name
  include Reports

  def initialize(name_string)
    @name = name_string
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

  when_reporting :title do |reportable|
    @title
  end
end
