class UpdatePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def read?
    true
  end

  def new?
    create?
  end

  def create?
    true
  end
end
