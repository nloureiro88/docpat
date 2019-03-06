class TopicsController < ApplicationController
  before_action :find_patient
  before_action :set_topic, only: %i(show refresh log deactivate)

  def index
    if params[:query].present?
      @topics = policy_scope(Topic).where(patient: @patient, status: "active").order('created_at DESC').global_search(params[:query])
    else
      @topics = policy_scope(Topic).where(patient: @patient, status: "active").order('created_at DESC')
    end
  end

  def show
    authorize Topic
    if params[:query].present?
      @updates = policy_scope(Topic).updates.where(topic: @topic).order('created_at DESC').update_search(params[:query])
    else
      @updates = policy_scope(Topic).updates.where(topic: @topic).order('created_at DESC')
    end
  end

  def new
  end

  def create
  end

  def refresh
  end

  def log
  end

  def deactivate
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
    @patient = @topic.patient
  end

  def find_patient
    @patient = User.find(params[:patient_id])
  end

  def topic_params
    params.require(:topic).permit(:patient_id, :category_id, :title, :subcode)
  end
end
