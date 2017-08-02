class Campaign < ApplicationRecord
  belongs_to :user
  has_many :contacts
  accepts_nested_attributes_for :contacts
  validates :name, presence: true

end
