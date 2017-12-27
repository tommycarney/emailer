class AddStatusIdToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :status, :integer, default: 0
  end
end
