class TopicPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  def index?
    true
  end

  def create?
    true
  end

  def new?
    create?
  end

  def log?
    true
  end

  def refresh?
    log?
  end

  def deactivate?
    true
  end
end
