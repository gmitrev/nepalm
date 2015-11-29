class WorkLogService
  def initialize(user, task, work_log_params)
    @user = user
    @task = task
    @work_log_params = work_log_params
  end

  def execute
    return unless validate!

    work_log_params = @work_log_params.merge({
      user: @user,
      task: @task,
    })

    WorkLog.create(work_log_params)
  end

  class << self
    def execute(*args)
      new(*args).execute
    end
  end

  private

  def validate!
    ensure_user_has_access_to_task!
  end

  def ensure_user_has_access_to_task!
    @user.all_tasks.include?(@task)
  end

end
