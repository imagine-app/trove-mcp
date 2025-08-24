class Api::ApplicationController < ApplicationController
  skip_before_action :require_authentication
  before_action :authenticate_api_user
  before_action :set_current_user_vaults

  private

  def authenticate_api_user
    unless current_user
      render json: { error: "Authentication required" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= begin
      if (session_record = find_session_by_cookie)
        session_record.user
      end
    end
  end

  def find_session_by_cookie
    Session.find_by(id: cookies.signed[:session_id]) if cookies.signed[:session_id]
  end

  def set_current_user_vaults
    @current_user_vaults = current_user&.vaults || Vault.none
  end

  def render_errors(resource)
    render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
  end

  def render_not_found(message = "Resource not found")
    render json: { error: message }, status: :not_found
  end

  def render_forbidden(message = "Access denied")
    render json: { error: message }, status: :forbidden
  end
end
