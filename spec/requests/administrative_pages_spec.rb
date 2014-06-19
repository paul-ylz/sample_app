require 'spec_helper'

describe 'Administration pages' do
  let(:admin) { create(:admin) }
  let(:bart) { create(:user) }
  let(:lisa) { create(:user) }

  subject { page }

  describe "when non-admin tries to delete another user" do
    before do
      sign_in bart, no_capybara: true
      delete user_path(lisa)
    end
    specify { expect(response).to redirect_to root_url }
  end

  # Ex 9.6.1 Testing that a user cannot change admin attribute
  #
  describe "admin attribute cannot be edited from web" do
    let(:params) do
      { user:
        {
        admin: true,
        password: bart.password,
        password_confirmation: bart.password
        }
      }
    end
    before do
      sign_in bart, no_capybara: true
      patch user_path bart, params
    end
    specify { expect(bart.reload.admin).to eq false }
  end

  describe "when admin visits user index" do
    before do
      create(:user)
      sign_in admin
      visit users_path
    end
    it { should have_link('delete', href: user_path(User.first)) }
    it { should_not have_link('delete', href: user_path(admin)) }
    it "should delete a user" do
      expect do
        # Capybara will use the first delete it finds
        click_link('delete', match: :first)
      end.to change(User, :count).by(-1)
    end
  end

  # Ex 9.6.9 Admin cannot destroy themselves
  #
  describe "when admin tries to delete self" do
    before { sign_in admin, no_capybara: true }
    it "should not delete admin" do
      expect{ delete user_path(admin) }.not_to change(User, :count).by(-1)
    end
    before { delete user_path(admin) }
    specify { expect(response).to redirect_to root_url }
  end
end
