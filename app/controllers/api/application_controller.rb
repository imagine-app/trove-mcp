class Api::ApplicationController < ApplicationController
  before_action :authenticate_user
  before_action :set_current_user_vaults

  private

  def authenticate_user
    unless current_user
      render json: { error: "Authentication required" }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
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
end
