class ContactsImporter
  attr_reader :campaign, :errors

  def initialize(campaign)
    @campaign = campaign
    @errors = []
  end

  def valid?
    return false unless csv_exists? && csv_valid?
    contacts_valid?(campaign)
  end


  def import
    CSV.parse(csvstring, headers: true).each do |row|
      contact = campaign.contacts.create(row.select {|attribute| valid_email?(attribute[1]) }.to_h)
      row.reject {|attribute| valid_email?(attribute[1]) }.each do |attribute|
        contact.contact_attributes.create(attribute_name:attribute[0], attribute_value: attribute[1])
      end
    end
  end

  private

  def csvstring
    @campaign.csvstring
  end

  def valid_email?(email)
    email =~ Devise.email_regexp
  end

  def contacts_valid?(campaign)
    return unless errors.empty? && csv_contains_email_header?
    all_contacts = []
    CSV.parse(csvstring, headers: true).each do |row|
      contact = campaign.contacts.new(row.select {|attribute| valid_email?(attribute[1]) }.to_h)
       all_contacts << contact
      unless contact.valid?
         errors << "user is invalid: #{contact.errors}"
      end
    end
    all_contacts.all? {|contact| contact.valid? }
  end

  def csv_contains_email_header?
    CSV.parse(csvstring, headers: true).each do |row|
      unless row.any? {|attribute| valid_email?(attribute[1]) }
        errors << "CSV file must contain an email column"
        return false
      end
    end
  end

  def csv_exists?
    return true unless csvstring.nil?
    errors << "CSV string does not exist: #{truncate(csvstring, 50)}"
  end

  def csv_valid?
    begin
      CSV.parse(csvstring, headers:true)
    rescue ArgumentError
      errors << "#{truncate(csvstring, 50)} is not a CSV that we can read."
    end
  end
end
