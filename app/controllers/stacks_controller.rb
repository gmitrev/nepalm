class StacksController < ApplicationController
  before_action :set_stack, only: [:show, :edit, :update, :destroy, :members,
                                   :new_member, :add_member, :subscribe,
                                   :unsubscribe, :archive]
  before_action :set_project

  before_action only: [:new_member, :add_member, :archive] do
    authorize_user!(@stack)
  end

  before_action :authenticate_user!

  def index
    @stacks = Stack.all
  end

  def show
    @comments, @unread_ids = @stack.latest_comments(current_user)
    @all_comments_count = @stack.comments.count
  end

  def new
    @stack = Stack.new
  end

  def edit
  end

  def create
    @stack = Stack.setup(stack_params, @project.id, current_user)

    respond_to do |format|
      if @stack.save
        format.html { redirect_to project_stack_path(@project, @stack), notice: 'Stack was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stack.update(stack_params)
        format.html { redirect_to project_stack_path(@project, @stack), notice: 'Stack was successfully updated.' }
        format.json { render :show, status: :ok, location: @stack }
      else
        format.html { render :edit }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @stack.destroy

    respond_to do |format|
      format.html { redirect_to @project, notice: 'Stack was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def members
  end

  def new_member
  end

  def add_member
    respond_to do |format|
      user = User.find_by_email(params[:users])
      if user
        if !user.stacks.include?(@stack) && user.stacks << @stack && @stack.add_user(user)
          format.html { redirect_to members_project_stack_path(@project, @stack), notice: 'User successfully added to stack.' }
        else
          format.html { redirect_to members_project_stack_path(@project, @stack), notice: 'User is already in this stack.' }
        end
      else
        format.html { redirect_to new_member_project_stack_path(@project, @stack), alert: 'User not found.' }
      end
    end
  end

  def subscribe
    CommentSubscription.find_or_create_by(user: current_user, stack: @stack).subscribe!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def unsubscribe
    CommentSubscription.find_or_create_by(user: current_user, stack: @stack).unsubscribe!

    respond_to do |format|
      format.json { head :no_content }
    end
  end

  def archive
    @stack.toggle_archive!

    respond_to do |format|
      format.html { redirect_to @project, notice: 'Stack was successfully archived.' }
      format.json { head :no_content }
    end
  end

  def files

  end

  private

  def set_stack
    @stack = current_user.stacks.find(params[:id])
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end

  def stack_params
    params.require(:stack).permit(:name, :summary)
  end
end
