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

  def updates_params
    params.require(:update).permit(:topic_id, :user_id, :diagnosis, :next_steps, :read_at, :read_by)
  end
end
