class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :configure_permitted_parameters, if: :devise_controller?

  def admin_for?(stack)
    current_user.membership(stack).admin?
  end

  def authorize_user!(stack)
    redirect_to :root, notice: 'Not authorized' unless admin_for?(stack)
  end

  helper_method :admin_for?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :password, :password_confirmation, :remember_me) }
  end

end
