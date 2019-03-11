class UserPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.all
    end
  end

  # Patients controller

  def show?
    true
  end

  def doctors?
    true
  end

  def doc_search?
    true
  end

  def accept_family?
    true
  end

  def rem_family?
    true
  end

  def add_doctor?
    true
  end

  def rem_doctor?
    true
  end

  def praise_toggle?
    true
  end
end
