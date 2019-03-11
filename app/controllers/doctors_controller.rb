class DoctorsController < ApplicationController
  def index
     # @patient = User.find(params[:patient_id])

     #@doctors = policy_scope(Doctor).where(user_type: "doctor")

     @doctors = policy_scope(User).all

  end

  def show
  end
end
