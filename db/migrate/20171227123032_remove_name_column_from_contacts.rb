class RemoveNameColumnFromContacts < ActiveRecord::Migration[5.0]
  def change
    remove_column :contacts, :name, :string
  end
end
