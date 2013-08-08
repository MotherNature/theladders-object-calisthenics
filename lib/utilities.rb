module HumanReadableDelegation
  def self.included(mod)
    mod.class_eval do
      alias_method :redirectee, :__getobj__
    end
  end
end

