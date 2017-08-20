class Campaign < ApplicationRecord
  belongs_to :user
  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts
  validates :name, presence: true, uniqueness: true

end
