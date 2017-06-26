class CampaignsController < ApplicationController
  before_action :set_campaign, only: [:show, :edit, :update, :destroy]


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

  def send(argument)
      @campaign = Campaign.find_by_id(params[:id])
      token = Token.find_by_email(@campaign.user.email)
      Gmail.new(client_id: Rails.application.secrets.client_id, client_secret: Rails.application.secrets.client_secret, refresh_token: token.access_token)

      @campaign.contacts.each do |contact|
        m = Gmail::Message.new(
            from: "\"Thomas Carney\" <tommycarney@gmail.com>",
            to: "#{contact.email}",
            subject: @campaign.name,
            text: render_email(contact, @campaign.email),
            html: render_email(contact, @campaign.email)
          )
        m.create_draft
      end
      redirect_to root_url, notice: "Emails sent!"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_campaign
      @campaign = Campaign.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def campaign_params
      params.require(:campaign).permit(:name, :email)
    end

    def render_email(contact, email)
      email.gsub(/{{[a-zA-Z0-9]+}}/) {|var| contact.send(var.scan(/[^({{|}})]/).join) }
    end

    def send_email(contact, campaign)

    end
end
