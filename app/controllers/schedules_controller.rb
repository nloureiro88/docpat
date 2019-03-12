class SchedulesController < ApplicationController
  #before_action :find_patient

  def index
    @patient = User.find(params[:patient_id])
    if params[:query].present?
      source_schedules = policy_scope(Schedule).order('created_at DESC').schedules_search(params[:query])
    else
      source_schedules = policy_scope(Schedule).order('created_at DESC')
    end
    @schedules = source_schedules.select { |schedule| schedule.topic.status == "active" && schedule.topic.patient == @patient }

  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def deactivate
  end
end
