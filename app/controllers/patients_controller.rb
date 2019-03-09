class PatientsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:doctors]
  # TO REMOVE

  def show
  end

  def doctors
    authorize User
  end

  def accept_family
  end

  def rem_family
  end

  def add_doctor
  end

  def rem_doctor
  end
end
