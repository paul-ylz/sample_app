require 'spec_helper'

describe "In reply to"  do 

	let(:bart) { create(:user, name: 'Bart Simpson', username: 'bartman') }
	let(:millhouse) { create(:user, name: 'Millhouse Van Houten', 
		username: 'millhouse')}
	let(:micropost) { build(:micropost, user: bart, in_reply_to: millhouse.id, content: "@millhouse Eat my shorts!") }

	describe "micropost that starts with @username" do 
		before do 
			sign_in bart
			visit root_path
			fill_in 'micropost_content', with: micropost.content
			click_button 'Post'
			click_link 'Sign out'
			sign_in millhouse
			visit root_path
		end
		
		it "should appear in recipient's feed" do 
			expect(page).to have_content micropost.content
		end

	end

end