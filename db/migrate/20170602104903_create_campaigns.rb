class CreateCampaigns < ActiveRecord::Migration[5.0]
  def change
    create_table :campaigns do |t|
      t.references :user, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
