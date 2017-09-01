class ContactsImporter
  attr_reader :campaign, :errors

  def initialize(args)
    @campaign = args[:campaign]
    @file     = args[:file]
    @errors = []
  end

  def valid?
    return false unless csv_exists? && csv_valid?
    contacts_valid?(campaign)
  end

  def file_path
    @file.path
  end


  def import
    CSV.foreach(file_path, headers: true) do |row|
      contact = campaign.contacts.create(row.select {|attribute| valid_email?(attribute[1]) }.to_h)
      row.reject {|attribute| valid_email?(attribute[1]) }.each do |attribute|
        contact.add_attribute(attribute)
      end
    end
  end


  def valid_email?(email)
    email =~ Devise.email_regexp
  end

  def contacts_valid?(campaign)
    return false unless errors.empty? && csv_contains_email_header?
    all_contacts = []
    CSV.foreach(file_path, headers: true) do |row|
      contact = campaign.contacts.new(row.select {|attribute| valid_email?(attribute[1]) }.to_h)
       all_contacts << contact
      unless contact.valid?
         errors << "user is invalid: #{contact.errors}"
      end
    end
    all_contacts.all? {|contact| contact.valid? }
  end

  def csv_contains_email_header?
    CSV.foreach(file_path, headers: true) do |row|
      unless row.any? {|attribute| valid_email?(attribute[1]) }
        errors << "CSV file must contain an email column"
        return false
      end
    end
    return true
  end

  def csv_exists?
    return true if File.open(file_path)
    errors << "CSV file does not exist: #{file_path}"
  end

  def csv_valid?
    begin
      CSV.open(file_path, headers: true)
      return true
    rescue ArgumentError
      errors << "#{file_path} is not a CSV that we can read."
    end
  end
end
