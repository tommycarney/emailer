class Contact < ApplicationRecord
  belongs_to :campaign
  validates :email, uniqueness: { scope: :campaign }
end
