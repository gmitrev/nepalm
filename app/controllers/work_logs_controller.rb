class WorkLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_task, only: [:create]

  def create
    WorkLogService.execute(current_user, @task, work_log_params)

    redirect_to :back
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_task
    @task = Task.find(params[:task_id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_log_params
    params.require(:work_log).permit(:time, :comment)
  end
end
