require 'rails_helper'

RSpec.describe EmailJob, type: :job do
  it "renders the markdown into html" do
    body = "#a h1 title"
    expect(EmailJob.html_part(body)).to include('<h1>a h1 title</h1>')
  end

  it "queues up a job" do
    ActiveJob::Base.queue_adapter = :test
    Sidekiq::Testing.fake!
    arguments = { sender: "test",
                  subject: "test",
                  email: "test@test.com",
                  body: "test",
                  token: "test"
                }
    expect { EmailJob.perform_later(arguments)
    }.to have_enqueued_job.with(arguments)
  end
end
