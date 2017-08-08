class ContactsImporter
  attr_reader :campaign, :file_path, :errors

  def initialize(campaign, file_path)
    @campaign = campaign
    @file_path = file_path
    @errors = []
  end

  def valid?
    file_exists? && csv_file?
  end

  def data_valid?
    contacts_valid?
  end

  def import
    CSV.foreach(file_path, headers: true) do |row|
      contact = campaign.contacts.create(row.to_hash)
    end
  end

  private

  def contacts_valid?
    return unless @errors.empty?
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

  def csv_file?
    begin
      CSV.read(file_path, :encoding => 'utf-8')
    rescue ArgumentError
      errors << "#{file_path} is not a CSV that we can read."
    end
  end
end
