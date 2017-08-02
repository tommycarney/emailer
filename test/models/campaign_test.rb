require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  test "campaign attributes must not be empty" do
    campaign = Campaign.new
    assert campaign.invalid?
  end
end
