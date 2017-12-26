class CampaignsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_campaign, only: [:show, :edit, :update, :destroy, :send_templated_email, :import]
  helper_method :render_email


  # GET /campaigns
  # GET /campaigns.json
  def index
    @campaigns = current_user.campaigns
  end

  # GET /campaigns/1
  # GET /campaigns/1.json
  def show
    if @campaign.user_id != current_user.id
      redirect_to campaigns_url
      flash[:notice] = 'A typo in the URL! Check out your campaigns below'
    end
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
        format.html { redirect_to upload_campaign_contacts_path(@campaign), notice: 'Campaign was successfully created.' }
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
        format.html { render :edit; flash[:notice] = 'Campaign was successfully updated.' }
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
      token = Token.find_by_email(@campaign.user.email)
      token.update_token!
      @campaign.contacts.each do |contact|
        EmailJob.perform_later(
                        sender:   @campaign.user.email,
                        subject:  @campaign.name,
                        email:    contact.email,
                        body:     @campaign.render(contact),
                        token:    token.refresh_token
                        )
      end
      redirect_to(root_url, notice: "We just sent #{@campaign.contacts.count} emails via your Gmail account.")
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
end
