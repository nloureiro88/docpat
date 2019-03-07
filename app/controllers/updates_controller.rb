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

  private

  def updates_params
    params.require(:update).permit(:topic_id, :user_id, :diagnosis, :next_steps)
  end
end
