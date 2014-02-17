require 'spec_helper'

describe 'Microposts' do 
	let(:mona) { create(:user, name: 'Mona Simpson') }
	let!(:m1) { create(:micropost, user: mona, content: 'How I wet your mother') }
	let!(:m2) { create(:micropost, user: mona, content: 'No disgrace like home') }

	subject { page } 

	describe "on show user page (profile)" do 
		before do 
			sign_in mona
		end
		it { should have_title mona.name }
		it { should have_selector 'h3', text: mona.microposts.count }
		it { should have_content(m1.content) }
		it { should have_content(m2.content) }
	end

	describe "Authorization" do 

		describe "Unauthenticated users" do 

			describe "submit POST to Microposts#create" do 
				before { post microposts_path }
				specify { expect(response).to redirect_to signin_path }
			end

			describe "submit DELETE to Microposts#destroy" do 
				before { delete micropost_path m1 }
				specify { expect(response).to redirect_to signin_path }
			end

		end
	end

end