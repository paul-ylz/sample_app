require 'spec_helper'
# Chap 11
# Testing Ajax with xhr. Note that xhr method is not available in integration
# tests.
#
describe RelationshipsController do
  let(:lisa) { create(:user, name: 'Lisa Simpson') }
  let(:colin) { create(:user, name: 'Colin') }

  before { sign_in lisa, no_capybara: true }

  describe 'creating a relationship with Ajax' do
    it "should increment the Relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: colin.id }
      end.to change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: colin.id }
      expect(response).to be_success
    end
  end

  describe 'destroying a relationship with Ajax' do
    before { lisa.follow!(colin) }
    let(:relationship) { lisa.relationships.find_by(followed_id: colin.id) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.to change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      expect(response).to be_success
    end
  end
end
