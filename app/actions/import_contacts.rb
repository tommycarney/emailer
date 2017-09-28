class ImportContacts
  attr_reader :campaign, :errors

  def initialize(args)
    @campaign = args[:campaign]
    @file     = args[:file]
    @errors   = []
  end

  def valid?
    csv_exists? && csv_valid? && csv_contains_email_header?
  end

  def import
    return false unless valid?
    CSV.foreach(file_path, headers: true) do |row|
      create_contact_from(row)
    end
    return true
  end

  private

  def file_path
    @file.path
  end

  def create_contact_from(row)
    contact = campaign.contacts.create(row.select {|attribute| valid_email?(attribute[1]) }.to_h)
    row.reject {|attribute| valid_email?(attribute[1]) }.each do |attribute|
      contact.add_attribute(attribute)
    end
  end

  def valid_email?(email)
    email =~ Devise.email_regexp
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
