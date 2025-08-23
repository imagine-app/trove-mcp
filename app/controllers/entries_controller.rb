class EntriesController < ApplicationController
  before_action :require_login
  before_action :set_vault
  before_action :set_entry, only: [ :show, :edit, :update, :destroy ]

  def index
    @entries = @vault.entries.includes(:entriable)
  end

  def show
  end

  def new
    @entry = @vault.entries.build
    @entry_type = params[:type] || "Entry::Message"
  end

  def create
    @entry = @vault.entries.build(entry_params.except(:entriable_attributes, :type))
    @entry_type = entry_params[:type]

    # Handle delegated type creation
    case @entry_type
    when "Entry::Email"
      mailbox = @vault.mailboxes.first || @vault.mailboxes.create!
      email = Entry::Email.new(entry_params[:entriable_attributes].merge(mailbox: mailbox))
      @entry.entriable = email
    when "Entry::Message"
      @entry.entriable = Entry::Message.new(entry_params[:entriable_attributes])
    when "Entry::Link"
      @entry.entriable = Entry::Link.new(entry_params[:entriable_attributes])
    end

    if @entry.save
      redirect_to [ @vault, @entry ], notice: "Entry was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @entry_type = @entry.entriable_type
  end

  def update
    if @entry.update(entry_params.except(:entriable_attributes, :type))
      # Update entriable if provided
      if entry_params[:entriable_attributes].present?
        @entry.entriable.update(entry_params[:entriable_attributes])
      end
      redirect_to [ @vault, @entry ], notice: "Entry was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @entry.destroy
    redirect_to [ @vault, :entries ], notice: "Entry was successfully deleted."
  end

  private

  def set_vault
    @vault = current_user.vaults.find(params[:vault_id])
  end

  def set_entry
    @entry = @vault.entries.find(params[:id])
  end

  def entry_params
    params.require(:entry).permit(:title, :description, :type,
                                  entriable_attributes: [ :text, :url, :title, :to, :from, :subject, :body, :cc, :received_at ])
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
