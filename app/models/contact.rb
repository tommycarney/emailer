class Contact < ApplicationRecord
  belongs_to :campaign
  has_many :contact_attributes, dependent: :destroy
end
