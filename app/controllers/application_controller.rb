class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  protected

  def current_user
    Current.user
  end
  helper_method :current_user

  def logged_in?
    current_user.present?
  end
  helper_method :logged_in?
end
