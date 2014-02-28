require 'spec_helper'

describe 'PasswordResets' do 

	let(:blinky) { create(:user, name: 'Blinky Three Eye') }

	describe 'when blinky requests a password reset' do 
		before do 
			visit root_url
			click_link 'Sign in'
			click_link 'Forgot password'
			fill_in :email, with: blinky.email
		end

		specify do 
			expect do 
				click_button 'Send password reset link'
			end.to change(ActionMailer::Base.deliveries, :count).by(1)
		end

		describe "it should email blinky" do 
			before { click_button 'Send password reset link' }
			specify { expect(ActionMailer::Base.deliveries.last.to).to eq [blinky.email] }
		end		
	end

	describe "when blinky clicks the reset link" do 
		before do 
			blinky.send_password_reset
			visit edit_password_reset_url(blinky.password_reset_token)
			fill_in 'Password', with: 'newpassword'
			fill_in 'Password confirmation', with: 'newpassword'
			click_button 'Update password'
		end
		specify { expect(page).to have_content 'Password has been reset' }
	end
end
