class VaultsController < ApplicationController
  before_action :set_vault, only: [ :show, :edit, :update, :destroy ]

  def index
    @vaults = current_user.vaults
  end

  def show
    @entries = @vault.entries.includes(:entriable).limit(10)
    @contexts = @vault.contexts.limit(5)
  end

  def new
    @vault = Vault.new
  end

  def create
    @vault = Vault.new(vault_params)

    if @vault.save
      @vault.memberships.create!(user: current_user, role: :manager)
      redirect_to @vault, notice: "Vault was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @vault.update(vault_params)
      redirect_to @vault, notice: "Vault was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @vault.destroy
    redirect_to vaults_url, notice: "Vault was successfully deleted."
  end

  private

  def set_vault
    @vault = current_user.vaults.find(params[:id])
  end

  def vault_params
    params.require(:vault).permit(:name)
  end

  def current_user
    Current.user
  end
end
