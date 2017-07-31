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


## Things I want to add

1. I want to use handsontable and sheetsjs to show an editable version of the imported CSV file, so users can quickly spot import errors and correct inconsistent data themselves on the spot.
