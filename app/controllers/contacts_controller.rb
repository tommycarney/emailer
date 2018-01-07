class ContactsController < ApplicationController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  before_action :show_progress_bar, only: [:upload]
  before_action :find_campaign, only: [:upload, :import]


  # GET /contacts
  # GET /contacts.json
  def index
    @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    @campaign = Campaign.find(params[:campaign_id])
    @contact = Campaign.find(params[:campaign_id]).contacts.new
  end

  # GET /contacts/1/edit
  def edit
  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Campaign.find_by_id(params[:campaign_id]).contacts.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render :show, status: :created, location: @contact }
      else
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upload
  end

  def import
    @contacts_importer = ImportContacts.new(campaign: @campaign, file: params[:file])
    if @contacts_importer.import
      redirect_to edit_campaign_path(params[:campaign_id]), notice: "Contacts imported."
    else
      @contacts_importer.errors.each { |error| @campaign.errors.add(:csv, error)}
      @contact = Campaign.find(params[:campaign_id]).contacts.new
      render :upload
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id])
    end

    def find_campaign
      @campaign = Campaign.find(params[:campaign_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.permit(:campaign_id, :email, :name)
    end

    def show_progress_bar
      @show_progress_bar = true
    end
end
