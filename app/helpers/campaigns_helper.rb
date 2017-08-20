module CampaignsHelper

  def render_email(contact, email)
    email.gsub(/{{[a-zA-Z0-9]+}}/) {|var| contact.contact_attributes.find_by(attribute_name: var.scan(/[^({{|}})]/).join).attribute_value }
  end

end
