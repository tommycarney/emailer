class EmailJob < ApplicationJob
  queue_as :default

  def perform(sender, subject, email, body, token)
    Gmail.client_id = Rails.application.secrets.client_id
    Gmail.client_secret = Rails.application.secrets.client_secret
    Gmail.refresh_token = token
    m = Gmail::Message.new(
        from: "\"Thomas Carney\" <tommycarney@gmail.com>",
        to: "#{email}",
        subject: subject,
        text: body,
        html: body
      )
    m.deliver
  end
end
