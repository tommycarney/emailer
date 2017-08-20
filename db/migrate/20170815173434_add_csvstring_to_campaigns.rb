class AddCsvstringToCampaigns < ActiveRecord::Migration[5.0]
  def change
    add_column :campaigns, :csvstring, :text
  end
end
