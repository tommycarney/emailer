class Contact < ApplicationRecord
  belongs_to :campaign
  has_many :contact_attributes, dependent: :destroy

  def add_attribute(attribute)
    self.contact_attributes.create(attribute_name:attribute[0], attribute_value: attribute[1])
  end
end
