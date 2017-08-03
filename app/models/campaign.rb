class Campaign < ApplicationRecord
  belongs_to :user
  has_many :contacts
  accepts_nested_attributes_for :contacts
  validates :name, presence: true, uniqueness: true


  def import(file)
    return false unless File.exists?(file.path)

    all_contacts = []
    CSV.foreach(file.path, headers: true) do |row|
      contact = self.contacts.new(row.to_hash)
       all_contacts << contact
      if contact.valid?
        contact.save
      end
    end
    all_contacts.all? {|contact| contact.valid? }
  rescue StandardError
    return false
  end

end
