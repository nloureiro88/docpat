class SchedulesController < ApplicationController
  #before_action :find_patient


  def index
    @patient = User.find(params[:patient_id])
   if params[:query].present?
     source_schedules = policy_scope(Schedule).where(status: 'active').order('created_at DESC').schedules_search(params[:query])
   else
     source_schedules = policy_scope(Schedule).where(status: 'active').order('created_at DESC')
   end
   @schedules = source_schedules.select { |schedule| schedule.topic.status == 'active' && schedule.topic.patient == @patient }
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
    @patient = @schedule.topic.patient
    authorize Topic

     respond_to do |format|
        if @schedule.save
          format.html { redirect_to patient_schedules_path, notice: 'Schedule was successfully created.' }
          #format.json { render :show, status: :created, location: @document }
        else
          format.html { render :new }
          #format.json { render json: @document.errors, status: :unprocessable_entity }
        end
      end
  end

  def edit
  end

  def update
  end

  def deactivate
  end


private


  def schedule_params
    params.require(:schedule).permit(:topic_id, :user_id,
                  :sc_type, :sc_title, :schedule,
                   :dosage, :notes, :date_start, :date_end,
                   :status, :read_by, :read_at)
  end


end

