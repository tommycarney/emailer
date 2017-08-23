class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :send_templated_email, :import]
  helper_method :render_email


  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = Campaign.all
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
  end

  # GET /campaigns/new
  def new
    @campaign = Campaign.new
  end

  # GET /campaigns/1/edit
  def edit
  end

  # POST /campaigns
  # POST /campaigns.json
  def create
    @campaign = current_user.campaigns.new(campaign_params)

    respond_to do |format|
      if @campaign.save
        format.html { redirect_to @campaign, notice: 'Campaign was successfully created.' }
        format.json { render :show, status: :created, location: @campaign }
      else
        format.html { render :new }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /campaigns/1
  # PATCH/PUT /campaigns/1.json
  def update
    respond_to do |format|
      if @campaign.update(campaign_params)
        format.html { redirect_to @campaign, notice: 'Campaign was successfully updated.' }
        format.json { render :show, status: :ok, location: @campaign }
      else
        format.html { render :edit }
        format.json { render json: @campaign.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /campaigns/1
  # DELETE /campaigns/1.json
  def destroy
    @campaign.destroy
    respond_to do |format|
      format.html { redirect_to campaigns_url, notice: 'Campaign was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def preview
    @campaign = Campaign.find_by_id(params[:id])
  end

  def send_templated_email
    # @campaign.send_templated_email...
      token = Token.find_by_email(@campaign.user.email)
      token.update_token!
      contacts = @campaign.contacts
      contacts.each do |contact|
        EmailJob.perform_later(
                        sender:   @campaign.user.email,
                        subject:  @campaign.name,
                        email:    contact.email,
                        body:     render_email(contact, @campaign.email),
                        token:    token.refresh_token
                        )
      end
      redirect_to(root_url, notice: "We just sent #{contacts.count} emails via your Gmail account.")
  end

  def import
    @campaign.update(csvstring: params[:csvstring])
    @contacts_importer = ContactsImporter.new(@campaign)

    if @contacts_importer.valid? #&& @contacts_importer.data_valid?
      @contacts_importer.import
      redirect_to edit_campaign_path(params[:campaign_id]), notice: "Contacts imported."
    else
      @contacts_importer.errors.each { |error| @campaign.errors.add(:csv, error)}
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name, :email, :csvstring)
    end

    def render_email(contact, template)
      template.gsub(/{{[a-zA-Z0-9]+}}/) {|var| contact.contact_attributes.find_by(attribute_name: var.scan(/[^({{|}})]/).join).attribute_value }
    end

end
