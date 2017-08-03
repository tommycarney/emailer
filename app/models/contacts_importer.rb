class ContactsImporter
  attr_reader :campaign, :file_path, :errors

  def initialize(campaign, file_path)
    @campaign = campaign
    @file_path = file_path
    @errors = []
  end

  def valid?
    file_exists? && contacts_valid?
  end

  def import
    CSV.foreach(file_path, headers: true) do |row|
      contact = campaign.contacts.create(row.to_hash)
    end
  end

  private

  def contacts_valid?
    all_contacts = []
    CSV.foreach(file_path, headers: true) do |row|
      contact = campaign.contacts.new(row.to_hash)
       all_contacts << contact
       unless contact.valid?
         errors << "user is invalid: #{contact.errors}"
      end
    end
    all_contacts.all? {|contact| contact.valid? }
  end

  def file_exists?
    return true if File.exists?(file_path)
    errors << "file does not exist: #{file_path}"
  end
end
