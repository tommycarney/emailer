class Campaign < ApplicationRecord
  belongs_to :user
  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts
  validates :name, presence: true
  validates :email, presence: true

  enum status: { draft: 0, sent: 1 }

  def render(contact)
    email.gsub(/{{[\w]+}}/) {|var| contact.contact_attributes.find_by(attribute_name: var.scan(/[^({{|}})]/).join).attribute_value }
  end

end
