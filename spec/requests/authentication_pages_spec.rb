require 'spec_helper'

describe "Authentication" do
  let(:bart) { create(:user, name: 'Bart Simpson') }

  subject { page }

  describe "visiting the login page" do
    before { visit signin_path }
    it { should have_title 'Sign in' }

    describe "invalid sign in" do
      before { click_button "Sign in" }
      it { should have_title 'Sign in' }

      describe "should display error message" do
        it { should have_error_message 'Invalid' }
      end

      # Test for persistence of flash error message. The issue is that flash
      # messages persist for 1 request. However, we render 'new' with invalid
      # login, which unlike 'redirect_to', does not count as a request.
      #
      describe "error message should not persist" do
        before { click_link "Home" }
        it { should_not have_error_message }
      end
    end

    describe "valid sign in" do
      before { sign_in bart }
      it { should have_signed_in_links(bart) }
      it { should_not have_link 'Sign in', href: signin_path }

      describe "followed by sign out" do
        before { click_link "Sign out" }
        it { should have_link "Sign in" }
        # Ex 9.6.3 check that signed out user no longer sees signed in links
        #
        it { should_not have_signed_in_links(bart) }
      end
    end
  end
end
