require 'rails_helper'

RSpec.describe "CampaignRequests", type: :request do
  it "queues up a background job" do
    ActiveJob::Base.queue_adapter = :test
    Sidekiq::Testing.fake!
    user = FactoryBot.create(:user)
    campaign = FactoryBot.create(:campaign, user: user)
    contact = FactoryBot.create(:contact, campaign: campaign)
    contact_attribute = FactoryBot.create(:contact_attribute, contact: contact)
    allow(Token).to receive(:find_by_email).and_return(double("token", update_token!: true, refresh_token: "sampletoken"))
    sign_in user
    expect { post send_campaign_campaign_path(campaign)
    }.to have_enqueued_job.with({:sender=> user.email, :subject=>campaign.name, :email=> contact.email ,  :body=> campaign.render(contact), :token=>"sampletoken"})
  end
end
