class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :add_files]
  before_action :set_stack, :set_project

  before_action :authenticate_user!

  # GET /comments
  # GET /comments.json
  def index
    @comments = @stack.comments
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  def create
    opts = {
      stack_id: params[:stack_id],
      user_id: current_user.id
    }

    @comment = Comment.new(comment_params.merge(opts))

    respond_to do |format|
      if @comment.save
        # Sendout notifications
        @comment.notify_all!
        format.html { render @comment }
        format.json { render :show, status: :created, location: @comment }
      else
        format.html { render :new }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to project_stack_path(@comment.stack.project, @comment.stack), notice: 'Files uploaded successfully.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { redirect_to project_stack_path(@comment.stack.project, @comment.stack), alert: @comment.errors.full_messages.join(". ") }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def add_files

    respond_to do |format|
      if !params['comment'] || !params['comment'].key?('attached_files')
        format.html { redirect_to project_stack_path(@comment.stack.project, @comment.stack), alert: "You need to select at least one file for upload."}
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      else
        attached_files = params['comment']['attached_files']
        required_disk_space = attached_files.flat_map(&:tempfile).map(&:size).reduce(:+)

        if @project.enough_disk_space_for?(required_disk_space) && @comment.add_files(attached_files)
          format.html { redirect_to project_stack_path(@comment.stack.project, @comment.stack), notice: 'Files uploaded successfully.' }
          format.json { render :show, status: :ok, location: @comment }
        else
          format.html { redirect_to project_stack_path(@comment.stack.project, @comment.stack), alert: I18n.t("errors.not_enough_disk_space", href: view_context.link_to('Upgrade project for more space and other features.', edit_project_path(@project)))}
          format.json { render json: @comment.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    @comment.destroy
    respond_to do |format|
      format.html { head :no_content }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_stack
    @stack = current_user.stacks.find(params[:stack_id])
  end

  def set_project
    @project = @stack.project
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_comment
    @comment = Comment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def comment_params
    params.require(:comment).permit(:body, :stack_id, :attached_files)
  end
end
