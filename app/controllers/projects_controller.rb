class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :archive, :star]

  before_action :set_stacks, only: [:show]

  before_action :authenticate_user!

  before_action :authenticate_owner!, only: [:edit, :update, :destroy, :archive]

  def index
    @active_projects   = current_user.active_projects
    @archived_projects = current_user.archived_projects
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    @project = Project.new(project_params.merge(owner_id: current_user.id))

    respond_to do |format|
      if @project.save
        format.html { redirect_to @project, notice: 'Project was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project, notice: 'Project was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @project.destroy

    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'Project was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def archive
    @project.toggle_archive!

    respond_to do |format|
      format.html { redirect_to projects_path, notice: 'Project was successfully archived.' }
      format.json { head :no_content }
    end
  end

  def star
    @project.star_for!(current_user)

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end

  private

  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def set_stacks
    @stacks          = current_user.stacks.active.where(project: @project)
    @archived_stacks = current_user.stacks.archived.where(project: @project)
  end

  def project_params
    params.require(:project).permit(:name)
  end

  def authenticate_owner!
    return if @project.owner == current_user

    redirect_to @project, alert: "You can't do that!"
  end
end
