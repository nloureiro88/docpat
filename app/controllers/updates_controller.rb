class UpdatesController < ApplicationController
  def index
    @patient = User.find(params[:patient_id])

    if params[:query].present?
      source_updates = policy_scope(Update).order('created_at DESC').updates_search(params[:query])
    else
      source_updates = policy_scope(Update).order('created_at DESC')
    end
    @updates = source_updates.select { |up| up.topic.status == "active" && up.topic.patient == @patient }
  end


def new
    @patient = User.find(params[:patient_id])
    @update = Update.new
    authorize Update
  end
def create
    @update = Update.new(update_params)
    @update.user = current_user
    authorize Update
    @patient = User.find(params[:patient_id])
    #@patient = @update.topic.patient
    #authorize Patient

     respond_to do |format|
        if @update.save
          format.html { redirect_to patient_updates_path, notice: 'Update was successfully created.' }
        else
          format.html { render :new }
        end
      end
  end

  def read
    authorize Update
    @patient = User.find(params[:patient_id])
    @update = Update.find(params[:id])
    @update.read_at = DateTime.now
    @update.read_by = current_user.id
    @update.save

    redirect_to patient_updates_path(@patient, query: params[:query])
  end

  private

  def update_params
    params.require(:update).permit(:topic_id, :topic_status, :user_id, :diagnosis, :next_steps, :read_at, :read_by)
  end
end
