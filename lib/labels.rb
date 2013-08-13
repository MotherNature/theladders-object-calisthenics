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
