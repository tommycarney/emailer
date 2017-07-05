module CampaignsHelper

  def render_email(contact, email)
    email.gsub(/{{[a-zA-Z0-9]+}}/) {|var| contact.send(var.scan(/[^({{|}})]/).join) }
  end

end
