require 'rails_helper'

RSpec.describe Campaign, type: :model do
 context "validations" do
   before do
     @user = create(:user)
     @campaign = create(:campaign, user_id: @user.id)
   end
   it "is valid with a name and an email" do
     expect(@campaign).to be_valid
   end
   it "is invalid without a name" do
     @campaign.name = nil
     expect(@campaign).to be_invalid
   end
   it "is invalid without an email" do
     @campaign.email = nil
     expect(@campaign).to be_invalid
   end
   it "has a default status of draft" do
     expect(@campaign.status).to eq("draft")
   end
  end

  it "given a contact, renders an email using contact_attributes of the contact" do
    user = create(:user)
    campaign = create(:campaign, user_id: user.id)
    contact = create(:contact, campaign_id: campaign.id)
    contact_attribute = create(:contact_attribute, contact_id: contact.id)
    expect(campaign.render(contact)).to eq("Hi #{contact_attribute.attribute_value}, what's up")
  end
end
