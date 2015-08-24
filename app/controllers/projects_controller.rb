class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :archive, :star]

  before_action :set_stacks, only: [:show]

  before_action :authenticate_user!

  before_action :authenticate_owner!, only: [:edit, :update, :destroy, :archive]

  # GET /projects
  # GET /projects.json
  def index
    @active_projects = current_user.active_projects
    @archived_projects = current_user.archived_projects
  end

  # GET /projects/1
  # GET /projects/1.json
  def show
  end

  # GET /projects/new
  def new
    @project = Project.new
  end

  # GET /projects/1/edit
  def edit
  end

  # POST /projects
  # POST /projects.json
  def create
    @project = Project.new(project_params)
    @project.owner = current_user

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

  # PATCH/PUT /projects/1
  # PATCH/PUT /projects/1.json
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

  # DELETE /projects/1
  # DELETE /projects/1.json
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

  # Use callbacks to share common setup or constraints between actions.
  def set_project
    @project = current_user.projects.find(params[:id])
  end

  def set_stacks
    @stacks          = current_user.stacks.active.where(project: @project)
    @archived_stacks = current_user.stacks.archived.where(project: @project)
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def project_params
    params.require(:project).permit(:name)
  end

  def authenticate_owner!
    return if @project.owner == current_user

    redirect_to @project, alert: "You can't do that!"
  end
end
