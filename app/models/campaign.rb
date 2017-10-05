class Campaign < ApplicationRecord
  belongs_to :user
  has_many :contacts, dependent: :destroy
  accepts_nested_attributes_for :contacts
  validates :name, presence: true, uniqueness: true

  def render(contact, template)
    template.gsub(/{{[a-zA-Z0-9]+}}/) {|var| contact.contact_attributes.find_by(attribute_name: var.scan(/[^({{|}})]/).join).attribute_value }
  end

end
