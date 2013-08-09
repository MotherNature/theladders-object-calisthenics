module RoleTaker # Rename to TakesRoles
  def take_on_role(role_module)
    extend role_module
  end
end

module HumanReadableDelegation
  def self.included(mod)
    mod.class_eval do
      alias_method :redirectee, :__getobj__
    end
  end
end

class RoleDelegator < SimpleDelegator
  include HumanReadableDelegation

  def self.assign_role_to(redirectee)
    self.new(redirectee)
  end

  # TODO: Can I make this a proper alias?
  def self.with_role_performed_by(redirectee)
    self.assign_role_to(redirectee)
  end
end
