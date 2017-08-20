class CreateContactAttributes < ActiveRecord::Migration[5.0]
  def change
    create_table :contact_attributes do |t|
      t.string :attribute_name
      t.string :attribute_value
      t.references :contact, foreign_key: true

      t.timestamps
    end
  end
end
