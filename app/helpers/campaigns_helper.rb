module CampaignsHelper

  def render_email(contact, email)
    email.gsub(/{{[a-zA-Z0-9]+}}/) {|var| contact.send(var.scan(/[^({{|}})]/).join) }
  end

  def send_email(contact, campaign)
    m = Gmail::Message.new(
        from: "\"Thomas Carney\" <tommycarney@gmail.com>",
        to: "#{contact.email}",
        subject: campaign.title,
        text: render_email(contact, campaign.email),
        html: render_email(contact, campaign.email)
      )
    m.create_draft
  end
end
