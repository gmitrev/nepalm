class StacksController < ApplicationController
  before_action :set_stack, only: [:show, :edit, :update, :destroy, :members, :new_member, :add_member, :subscribe, :unsubscribe]
  before_action :set_project

  before_action only: [:new_member, :add_member] do |m|
    authorize_user!(@stack)
  end

  before_action :authenticate_user!

  # GET /stacks
  # GET /stacks.json
  def index
    @stacks = Stack.all
  end

  # GET /stacks/1
  # GET /stacks/1.json
  def show
    @comments, @unread_ids = @stack.latest_comments(current_user)
    @all_comments_count = @stack.comments.count
  end

  # GET /stacks/new
  def new
    @stack = Stack.new
  end

  # GET /stacks/1/edit
  def edit
  end

  # POST /stacks
  # POST /stacks.json
  def create
    @stack = Stack.new(stack_params.merge({project_id: @project.id}))
    @stack.users << current_user
    @stack.memberships.select { |r| r[:user_id].to_i == current_user.id }.first.role = 'admin' # First user should be admin

    respond_to do |format|
      if @stack.save
        format.html { redirect_to @project, notice: 'Stack was successfully created.' }
        format.json { render :show, status: :created, location: @project }
      else
        format.html { render :new }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stacks/1
  # PATCH/PUT /stacks/1.json
  def update
    respond_to do |format|
      if @stack.update(stack_params)
        format.html { redirect_to @project, notice: 'Stack was successfully updated.' }
        format.json { render :show, status: :ok, location: @stack }
      else
        format.html { render :edit }
        format.json { render json: @stack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stacks/1
  # DELETE /stacks/1.json
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
      if user && !user.stacks.include?(@stack) && user.stacks << @stack
        @stack.comments.each { |c| c.mark_as_read!(for: user) }
        @stack.subscribe!(user)

        format.html { redirect_to members_project_stack_path(@project, @stack), notice: 'User successfully added to stack.' }
      else
        format.html { redirect_to members_project_stack_path(@project, @stack), alert: 'User not found.' }
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_stack
      @stack = current_user.stacks.find(params[:id])
    end

    def set_project
      @project = current_user.all_projects.select{ |r| r.id == params[:project_id].to_i }.first
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def stack_params
      params.require(:stack).permit(:name, :summary)
    end
end
