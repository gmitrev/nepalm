class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def admin_for?(stack)
    current_user.membership(stack).admin?
  end

  def authorize_user!(stack)
    redirect_to :root, notice: 'Not authorized' unless admin_for?(stack)
  end

  helper_method :admin_for?
end
