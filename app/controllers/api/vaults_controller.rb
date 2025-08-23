class Api::VaultsController < Api::ApplicationController
  before_action :set_vault, only: [:show, :update, :destroy]

  def index
    @vaults = @current_user_vaults
    render json: @vaults
  end

  def show
    render json: @vault
  end

  def create
    @vault = Vault.new(vault_params)
    
    if @vault.save
      # Add current user as manager
      @vault.memberships.create!(user: current_user, role: :manager)
      render json: @vault, status: :created
    else
      render_errors(@vault)
    end
  end

  def update
    if @vault.update(vault_params)
      render json: @vault
    else
      render_errors(@vault)
    end
  end

  def destroy
    @vault.destroy
    head :no_content
  end

  private

  def set_vault
    @vault = @current_user_vaults.find_by(id: params[:id])
    render_not_found("Vault not found") unless @vault
  end

  def vault_params
    params.require(:vault).permit(:name)
  end
end