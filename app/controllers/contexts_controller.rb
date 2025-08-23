class ContextsController < ApplicationController
  before_action :require_login
  before_action :set_vault
  before_action :set_context, only: [ :show, :edit, :update, :destroy, :add_entry, :remove_entry ]

  def index
    @contexts = @vault.contexts
  end

  def show
    @available_entries = @vault.entries.where.not(id: @context.entry_ids)
  end

  def new
    @context = @vault.contexts.build
  end

  def create
    @context = @vault.contexts.build(context_params)

    if @context.save
      redirect_to [ @vault, @context ], notice: "Context was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @context.update(context_params)
      redirect_to [ @vault, @context ], notice: "Context was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @context.destroy
    redirect_to [ @vault, :contexts ], notice: "Context was successfully deleted."
  end

  def add_entry
    @entry = @vault.entries.find(params[:entry_id])
    @context.entries << @entry unless @context.entries.include?(@entry)
    redirect_to [ @vault, @context ], notice: "Entry added to context."
  end

  def remove_entry
    @entry = @context.entries.find(params[:entry_id])
    @context.entries.delete(@entry)
    redirect_to [ @vault, @context ], notice: "Entry removed from context."
  end

  private

  def set_vault
    @vault = current_user.vaults.find(params[:vault_id])
  end

  def set_context
    @context = @vault.contexts.find(params[:id])
  end

  def context_params
    params.require(:context).permit(:name, :description, :autotag)
  end

  def require_login
    unless current_user
      redirect_to login_path, alert: "You must be logged in to access this page."
    end
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
end
