class Api::MailboxesController < Api::ApplicationController
  before_action :set_vault
  before_action :set_mailbox, only: [ :show, :update, :destroy ]

  def index
    @mailboxes = @vault.mailboxes.includes(:emails)
    render json: @mailboxes.as_json(include: :emails)
  end

  def show
    render json: @mailbox.as_json(include: :emails)
  end

  def create
    @mailbox = @vault.mailboxes.build

    if @mailbox.save
      render json: @mailbox, status: :created
    else
      render_errors(@mailbox)
    end
  end

  def update
    if @mailbox.update(mailbox_params)
      render json: @mailbox
    else
      render_errors(@mailbox)
    end
  end

  def destroy
    @mailbox.destroy
    head :no_content
  end

  private

  def set_vault
    vault = Vault.find_by(id: params[:vault_id])
    unless vault
      render_not_found("Vault not found") 
      return
    end
    
    @vault = @current_user_vaults.find_by(id: vault.id)
    unless @vault
      render_forbidden("Access denied")
      return
    end
  end

  def set_mailbox
    @mailbox = @vault.mailboxes.find_by(id: params[:id])
    render_not_found("Mailbox not found") unless @mailbox
  end

  def mailbox_params
    params.fetch(:mailbox, {}).permit()  # Mailbox has no editable attributes currently
  end
end
