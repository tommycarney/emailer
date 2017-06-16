class Contact < ApplicationRecord
  belongs_to :campaign

  def self.import(file, campaign_id)
    CSV.foreach(file.path, headers: true) do |row|
      contact = Campaign.find_by_id(campaign_id).contacts.create(row.to_hash)
      contact.save
    end
  end

end
