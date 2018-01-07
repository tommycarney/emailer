require 'rails_helper'
include ActionDispatch::TestProcess

RSpec.describe ImportContacts do
  let(:user) { create(:user)}
  let(:campaign) { create(:campaign, user_id: user.id ) }
  let(:importer) { ImportContacts.new(campaign: campaign, file: file)}

  describe "validating a CSV file" do
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
    describe "with a correctly formatted CSV file" do
      let(:file) { fixture_file_upload('files/3-contacts.csv', 'text/csv') }
      it "creates 3 new contacts on the campaign" do
        importer.import
        expect(campaign.contacts.map(&:email)).to match(["thomas@example.com", "caroline@example.com", "john@example.com"])
      end
    end

    describe "with a incorrect format of XML" do
      let(:file) { fixture_file_upload('files/xml-file.xml', 'text/xml') }
      it "returns false" do
        importer.import
        expect(importer.import).to be_falsey
      end
    end
    describe "without any file" do
      let(:file) { nil }
      specify { expect(importer).to_not be_valid }
    end
    describe "with an invalid file" do
      let(:file) { fixture_file_upload('files/xml-file.xml','image/jpeg' ) }
      specify { expect(importer).to_not be_valid }
    end
  end
end
