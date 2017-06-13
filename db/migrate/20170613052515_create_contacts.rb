class CreateContacts < ActiveRecord::Migration[5.0]
  def change
    create_table :contacts do |t|
      t.references :campaign, foreign_key: true
      t.string, :email
      t.string :name

      t.timestamps
    end
  end
end
