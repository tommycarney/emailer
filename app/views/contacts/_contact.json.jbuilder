json.extract! contact, :id, :campaign_id, :email, :name, :created_at, :updated_at
json.url contact_url(contact, format: :json)
