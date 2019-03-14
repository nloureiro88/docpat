class TopicsController < ApplicationController
  before_action :find_patient
  before_action :set_topic, only: %i(refresh log deactivate)

  def index
    if params[:query].present?
      @topics = policy_scope(Topic).where(patient: @patient, status: "active").order('created_at DESC').topics_search(params[:query])
    else
      @topics = policy_scope(Topic).where(patient: @patient, status: "active").order('created_at DESC')
    end
  end

  def new
    @topic = Topic.new
    @update = Update.new
    authorize Topic
    #authorize Document
  end

  def create
    @topic = Topic.new(topic_params)
    @topic.patient = @patient
    @update = Update.new(update_params)
    @update.topic = @topic
    @update.user = current_user
    authorize Topic
    authorize Update
    if @topic.save && @update.save
      redirect_to patient_topics_path(@patient, query: params[:query])
    else
      render :new
    end
  end

  def refresh
    # @update = Update.where(patient: @patient, topic: @topic).last
  end

  def log
    # @update = Update.new(update_params)
    # @update.topic = @topic
    # @update.user = current_user
    # authorize Update
    # if @update.save
    #   redirect_to patient_topics_path(@patient, query: params[:query])
    # else
    #   render :refresh
    # end
  end

  def deactivate
    authorize Topic
    @topic.status = "inactive"
    @topic.save

    @topic.documents.each do |item|
      item.status = "inactive"
      item.save
    end

    @topic.schedules.each do |item|
      item.status = "inactive"
      item.save
    end

    redirect_to patient_topics_path(@patient, query: params[:query])
  end

  private

  def set_topic
    @topic = Topic.find(params[:id])
  end

  def find_patient
    @patient = User.find(params[:patient_id])
  end

  def topic_params
    params.require(:topic).permit(:patient_id, :category_id, :title, :subcode)
  end

  def update_params
    params.require(:update).permit(:topic_id, :diagnosis, :next_steps, :topic_status)
  end
end
