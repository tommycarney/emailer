# Emailer App

The goal of this application is to send emails via a user's Gmail account.

## Use case

1. You want to send an email to 50 people on an excel sheet. You authorize the application to send email via your gmail account via an oAuth flow.

2. You import a CSV file with the name and email of the people you want to email.

3. You create a template email. For example:

```
Dear {{name}},

Thanks for joining the Berlin Barbell Club! Please let us know when you want to do your first intro class.

Best regards,

Thomas

```

4. The app shows you a preview of the emails it will send.

5. You send the emails, which are scheduled as background jobs to be processed.


## How to Start

### The Redis server for Sidekiq
Now, if I fire up my redis server via `brew services start redis` and start sidekiq via `bundle exec sidekiq`, I can see my jobs at http://localhost:3000/sidekiq
