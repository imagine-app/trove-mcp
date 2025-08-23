class Api::EntriesController < Api::ApplicationController
  before_action :set_vault
  before_action :set_entry, only: [ :show, :update, :destroy ]

  def index
    @entries = @vault.entries.includes(:entriable)
    render json: @entries.map { |entry| serialize_entry(entry) }
  end

  def show
    render json: serialize_entry(@entry)
  end

  def create
    @entry = @vault.entries.build(entry_params.except(:entriable_attributes, :type))

    # Handle delegated type creation
    case entry_params[:type]
    when "Entry::Email"
      mailbox = @vault.mailboxes.first || @vault.mailboxes.create!
      email = Entry::Email.new(entry_params[:entriable_attributes].merge(mailbox: mailbox))
      @entry.entriable = email
    when "Entry::Message"
      @entry.entriable = Entry::Message.new(entry_params[:entriable_attributes])
    when "Entry::Link"
      @entry.entriable = Entry::Link.new(entry_params[:entriable_attributes])
    else
      render json: { error: "Invalid entry type" }, status: :bad_request
      return
    end

    if @entry.save
      render json: serialize_entry(@entry), status: :created
    else
      render_errors(@entry)
    end
  end

  def update
    if @entry.update(entry_params.except(:entriable_attributes, :type))
      # Update entriable if provided
      if entry_params[:entriable_attributes].present?
        @entry.entriable.update(entry_params[:entriable_attributes])
      end
      render json: serialize_entry(@entry)
    else
      render_errors(@entry)
    end
  end

  def destroy
    @entry.destroy
    head :no_content
  end

  private

  def set_vault
    @vault = @current_user_vaults.find_by(id: params[:vault_id])
    render_not_found("Vault not found") unless @vault
  end

  def set_entry
    @entry = @vault.entries.find_by(id: params[:id])
    render_not_found("Entry not found") unless @entry
  end

  def entry_params
    params.require(:entry).permit(:title, :description, :type,
                                  entriable_attributes: [ :text, :url, :title, :to, :from, :subject, :body, :cc, :received_at ])
  end

  def serialize_entry(entry)
    {
      id: entry.id,
      title: entry.title,
      description: entry.description,
      type: entry.entriable_type,
      entriable_type: entry.entriable_type,
      created_at: entry.created_at,
      updated_at: entry.updated_at,
      entriable: entry.entriable.as_json
    }
  end
end
