class MembershipsController < ApplicationController
  prepend_before_action :set_membership, only: [:edit, :update, :destroy]

  before_action :authenticate_user!

  before_action do |m|
    authorize_user!(@organization)
  end

  def edit
  end

  def update
    respond_to do |format|
      if @membership.update(membership_params)
        format.html { redirect_to @organization, notice: 'Project was successfully updated.' }
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
      format.html { redirect_to @organization, notice: 'User was successfully removed from the organization.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
      @user = @membership.user
      @organization = @membership.organization
    end

    def membership_params
      params.require(:membership).permit(:role)
    end

end
