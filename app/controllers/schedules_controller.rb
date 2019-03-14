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
    @patient = User.find(params[:patient_id])
    @schedule = Schedule.new
    authorize Schedule
  end

  def create
    @schedule = Schedule.new(schedule_params)
    @schedule.user = current_user
    #@schedule.topic = Topic.where(patient: current_user).first
    authorize Topic
    @patient = User.find(params[:patient_id])
    #@patient = @schedule.topic.patient
    #authorize Patient

     respond_to do |format|
        if @schedule.save
          format.html { redirect_to patient_schedules_path, notice: 'Schedule was successfully created.' }
        else
          format.html { render :new }
        end
      end
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

  def schedule_params
    params.require(:schedule).permit(:topic_id, :user_id,
                  :sc_type, :sc_title, :schedule,
                   :dosage, :notes, :date_start, :date_end,
                   :status, :read_by, :read_at)
  end


end
