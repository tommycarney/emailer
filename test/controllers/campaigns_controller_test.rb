require 'test_helper'

class CampaignsControllerTest < ActionDispatch::IntegrationTest
  setup do

    @user = users(:one)
    @campaign = campaigns(:one)
    @token = tokens(:one)
    @user.campaigns << @campaign
    @user.token = @token
  end

  test "should get new" do
    get new_campaign_url
    assert_response :success
  end

  test "should get edit" do
    get edit_campaign_url(:id => @campaign.id)
    assert_response :success
  end

  test "should show campaign" do
    get campaign_url(@campaign)
    assert_response :success
  end

  test "should get preview" do
    get preview_campaign_campaign_url(:id => @campaign.id)
    assert_response :success
  end

  test "should get send" do
    get send_campaign_campaign_url(:id => @campaign.id)
    assert_redirected_to root_url
  end


end
