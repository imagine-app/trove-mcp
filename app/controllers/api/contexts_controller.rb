class Api::ContextsController < Api::ApplicationController
  before_action :set_vault
  before_action :set_context, only: [:show, :update, :destroy]

  def index
    @contexts = @vault.contexts
    render json: @contexts.as_json(methods: [:entries_count])
  end

  def show
    render json: @context.as_json(include: { entries: { include: :entriable } })
  end

  def create
    @context = @vault.contexts.build(context_params)
    
    if @context.save
      render json: @context, status: :created
    else
      render_errors(@context)
    end
  end

  def update
    if @context.update(context_params)
      render json: @context
    else
      render_errors(@context)
    end
  end

  def destroy
    @context.destroy
    head :no_content
  end

  def add_entry
    @entry = @vault.entries.find_by(id: params[:entry_id])
    
    if @entry
      @context.entries << @entry unless @context.entries.include?(@entry)
      render json: { message: "Entry added to context" }
    else
      render_not_found("Entry not found")
    end
  end

  def remove_entry
    @entry = @context.entries.find_by(id: params[:entry_id])
    
    if @entry
      @context.entries.delete(@entry)
      render json: { message: "Entry removed from context" }
    else
      render_not_found("Entry not found in context")
    end
  end

  private

  def set_vault
    @vault = @current_user_vaults.find_by(id: params[:vault_id])
    render_not_found("Vault not found") unless @vault
  end

  def set_context
    @context = @vault.contexts.find_by(id: params[:id])
    render_not_found("Context not found") unless @context
  end

  def context_params
    params.require(:context).permit(:name, :description, :autotag)
  end
end