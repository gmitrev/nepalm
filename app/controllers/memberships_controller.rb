class MembershipsController < ApplicationController
  prepend_before_action :set_membership, only: [:edit, :update, :destroy]

  before_action do
    authorize_user!(@stack)
  end

  before_action :authenticate_user!

  def edit
  end

  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to members_project_stack_path(@stack.project.id, @stack.id), notice: 'User role was successfully updated.' }
        format.json { render :show, status: :ok, location: @project }
      else
        format.html { render :edit }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @membership.destroy

    respond_to do |format|
      format.html { redirect_to members_project_stack_path(@stack.project.id, @stack.id), notice: 'User role was successfully removed from the stack.' }
      format.json { head :no_content }
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
    @user = @membership.user
    @stack = @membership.stack
  end

  def membership_params
    params.require(:membership).permit(:role)
  end
end
