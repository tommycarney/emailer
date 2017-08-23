class EmailJob < ApplicationJob
  queue_as :default

  def perform(args={})
    sender    = args[:sender]
    subject   = args[:subject]
    email     = args[:email]
    body      = args[:body]
    token     = args[:token]

    Gmail.client_id = Rails.application.secrets.client_id
    Gmail.client_secret = Rails.application.secrets.client_secret
    Gmail.refresh_token = token
    m = Gmail::Message.new(
        from: "#{sender}",
        to: "#{email}",
        subject: subject,
        text: body,
        html: body
      )
    m.deliver
  end
end
