class AddEmailToCampaign < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :email, :text
  end
end
