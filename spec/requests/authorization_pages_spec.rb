require 'spec_helper'

describe "Authorization" do 
	let(:moe) { create(:user, name: 'Moe Szyslak') }

	subject { page } 

	describe "Unauthenticated user in the Users controller" do 
		describe "should be redirected to sign in" do 
			before { visit edit_user_path moe }
			specify { expect(current_path).to eq signin_path }
			# Test for friendly forwarding
			# 
			describe "should be redirected to protected page after sign in" do 
				before do 
					fill_in "Email", with: moe.email
					fill_in "Password", with: moe.password
					click_button "Sign in"
				end
				it { should have_title 'Edit user' }
				describe "but revert to (redirect_to show user) on subsequent signin" do 
					before do
						click_link "Sign out"
						sign_in moe
					end
					it { should have_title moe.name}
				end
			end 
		end

		describe "submitting to the update action" do 
			before { patch user_path moe }
			describe "should be redirected to root" do
				specify { expect(response).to redirect_to signin_url }
			end
		end

		describe "visiting the user index" do 
			before { get users_path }
			describe "should be redirected to root" do 
				specify { expect(response).to redirect_to signin_url }
			end
		end

		describe "visiting the following page" do 
			before { visit following_user_path moe }
			it { should have_title 'Sign in' }
		end

		describe "visiting the followers page" do 
			before { visit followers_user_path moe }
			it { should have_title 'Sign in' }
		end
	end


	describe "Unauthenticated user in the Relationships controller" do 
		describe "submitting to the create action" do 
			before { post relationships_path }
			specify { expect(response).to redirect_to(signin_path) }
		end

		describe "submitting to the destroy action" do 
			before { delete relationship_path(1) }
			specify { expect(response).to redirect_to(signin_path) }
		end
	end


	describe "Unauthenticated user in the Microposts controller" do 
		describe "submitting to the create action" do 
			before { post microposts_path }
			specify { expect(response).to redirect_to signin_url }
		end

		describe "submitting to the destroy action" do 
			let(:m1) { create(:micropost, user: moe, content: 'The what?') }
			before { delete micropost_path m1 }
			specify { expect(response).to redirect_to signin_url }
		end
	end


	describe "Authenticated user attempting unauthorized tasks" do 
		let(:homer) { create(:user, name: 'Homer Simpson') }
		# Chap 9.2.2 We cannot use capybara for these tests because a user would
		# not be able to access these routes via browser links. 
		# 
		before { sign_in homer, no_capybara: true }

		describe "in the Users controller" do 
			describe "when Homer edits Moe's profile" do 
				before { get edit_user_path(moe) }
				specify { expect(response.body).not_to match(full_title('Edit User')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "when Homer updated Moe's profile" do 
				before { patch user_path(moe) }
				specify { expect(response).to redirect_to(root_url) }
			end

			# Ex 9.6.6 Signed in users should be redirected to root if they hit
			# User#new or User#create.
			# 
			describe 'when Homer tries to sign up again (Users#new)' do 
				before { get new_user_path }
				specify { expect(response).to redirect_to root_url }
			end

			describe 'when Homer tries to sign up again (Users#create)' do
				before { post users_path, { user:{ blah: 'blah'}} }
				specify { expect(response).to redirect_to root_url }
			end
		end
	end
end