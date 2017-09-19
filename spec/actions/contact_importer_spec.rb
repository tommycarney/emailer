require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe ContactsImporter do
  describe "validating a CSV file" do
    let(:user) { User.create(email:"emailer@example.com")}
    let(:campaign) { Campaign.create(name:"A test subject line", email: "Hi {{name}}, here's a line", user_id: user.id )}
    let(:importer) { ContactsImporter.new(campaign: campaign, file: file)}

    describe "with an incorrect format of XML" do
      let(:file) { fixture_file_upload('files/xml-file.xml', 'text/xml') }
      specify { expect(importer).to_not be_valid }
    end

    describe "with a correctly formatted CSV file" do
      let(:file) { fixture_file_upload('files/3-contacts.csv', 'text/csv') }
      specify { expect(importer).to be_valid }
    end
  end

  describe "uploading a CSV file" do
    let(:user) { User.create(email:"emailer@example.com")}
    let(:campaign) { Campaign.create(name:"A test subject line", email: "Hi {{name}}, here's a line", user_id: user.id )}
    let(:importer) { ContactsImporter.new(campaign: campaign, file: file)}

    describe "with a correctly formatted CSV file" do
      let(:file) { fixture_file_upload('files/3-contacts.csv', 'text/csv') }
      it "creates 3 new contacts on the campaign" do
        importer.import
        expect(campaign.contacts.reject {|contact| contact.id.nil?}.map(&:email)).to match(["thomas@example.com", "caroline@example.com", "john@example.com"])
      end
    end

    describe "with a incorrect format of XML" do
      let(:file) { fixture_file_upload('files/xml-file.xml', 'text/xml') }
      it "creates 3 new contacts on the campaign" do
        importer.import
        expect(campaign.contacts.map(&:email)).to match([])
      end
    end
  end

end
