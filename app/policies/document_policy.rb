class DocumentPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index_ex?
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

  def deactivate?
    true
  end
end
