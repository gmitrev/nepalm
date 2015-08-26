class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    current_user.update_attributes(user_params)

    respond_to do |format|
      format.json { respond_with_bip(current_user) }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name)
  end
end
