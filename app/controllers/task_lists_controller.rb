class TaskListsController < ApplicationController
  before_action :set_task_list, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!

  def index
    @task_lists = TaskList.all
  end

  def show
  end

  def new
    @task_list = TaskList.new
  end

  def edit
  end

  def create
    @task_list = TaskList.new(task_list_params)

    respond_to do |format|
      if @task_list.save
        format.html { redirect_to @task_list, notice: 'Task list was successfully created.' }
        format.json { render :show, status: :created, location: @task_list }
      else
        format.html { render :new }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @task_list.update(task_list_params)
        format.html { redirect_to @task_list, notice: 'Task list was successfully updated.' }
        format.json { render :show, status: :ok, location: @task_list }
      else
        format.html { render :edit }
        format.json { render json: @task_list.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @task_list.destroy
    respond_to do |format|
      format.html { redirect_to task_lists_url, notice: 'Task list was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_task_list
    @task_list = TaskList.find(params[:id])
  end

  def task_list_params
    params.require(:task_list).permit(:name, :stack_id)
  end
end
