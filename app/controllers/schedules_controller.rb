class SchedulesController < ApplicationController
  before_action :find_patient
  before_action :set_schedule, only: %i(edit update read deactivate)

  def index
    if params[:query].present?
      source_schedules = policy_scope(Schedule).where(status: 'active').order('created_at DESC').schedules_search(params[:query])
    else
      source_schedules = policy_scope(Schedule).where(status: 'active').order('created_at DESC')
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

  def read
    authorize Schedule
    @schedule.read_at = DateTime.now
    @schedule.read_by = current_user.id
    @schedule.save

    redirect_to patient_schedules_path(@patient, query: params[:query])
  end

  def deactivate
    authorize Schedule
    @schedule.status = "inactive"
    @schedule.save

    redirect_to patient_schedules_path(@patient, query: params[:query])
  end

  private

  def set_schedule
    @schedule = Schedule.find(params[:id])
  end

  def find_patient
    @patient = User.find(params[:patient_id])
  end
end
