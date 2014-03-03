require 'spec_helper'

describe 'Signup confirmation' do 

	describe 'sign up' do 
		let(:martin) { build(:user, name: 'Martin Prince') }

		before do 
			visit root_url
			click_link 'Sign up now!'
			fill_in 'Name', with: martin.name
			fill_in 'Email', with: martin.email
			fill_in 'Username', with: martin.username
			fill_in 'Password', with: martin.password 
			fill_in 'Confirm Password', with: martin.password
		end

		describe 'should email user' do 
			before do 
				ActionMailer::Base.deliveries = []
				click_button 'Create my account' 
			end

			specify { expect(User.last.active).to eq false }
			specify { expect(ActionMailer::Base.deliveries.last.to).to eq [martin.email] }
			specify { expect(User.find_by_email(martin.email).email_verification_token).not_to eq nil }
		end
	end


	describe 'visiting confirmation link' do 
		let(:bart) { create(:unconfirmed_user, name: 'Bart Simpson') }

		before { visit "/activate/#{bart.email_verification_token}" }

		specify { expect(page.title).to match(/Email confirmation/) }
		specify { expect(bart.reload.active).to eq true}
	end


	describe 'posting before confirmation' do 
		let(:lisa) { create(:unconfirmed_user, name: 'Lisa Simpson') }

		before do 
			sign_in lisa
			visit root_url 
			fill_in 'micropost_content', with: 'this post should not work'
		end

		specify { expect{click_button 'Post'}.not_to change(Micropost, :count).by(1) }

		describe "should advise user to confirm email" do 
			before { click_button 'Post' }

			specify { expect(page).to have_content('Please confirm your email') }
		end
	end
end