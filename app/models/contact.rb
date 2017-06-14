class Contact < ApplicationRecord
  belongs_to :campaign
  attr_accessor :email, :name

  def self.import(file, campaign_id)
    accessible_attributes = ['email', 'name']
    CSV.foreach(file.path, headers: true) do |row|
      contact = Campaign.find_by_id(campaign_id).contacts.new(row.to_hash.slice(*accessible_attributes))
      contact.save!
    end
  end
end
