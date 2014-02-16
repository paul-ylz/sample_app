require 'spec_helper'

describe "Authorization" do 
	let(:moe) { create(:user) }

	subject { page } 

	describe "Unauthenticated user visiting protected page" do 

		describe "should be redirected to sign in" do 
			before { visit edit_user_path moe }
			specify { expect(current_path).to eq signin_path }
	
			# Test for friendly forwarding
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
				specify { expect(response).to redirect_to signin_path }
			end
		end

		describe "visiting the user index" do 
			before { get users_path }
			describe "should be redirected to root" do 
				specify { expect(response).to redirect_to signin_path }
			end
		end
	end

	describe "Authenticated user performing unauthorized tasks" do 
		let(:homer) { create(:user) }
		# Chap 9.2.2 We cannot use capybara for these tests because a user would
		# not be able to access these routes via browser links. 
		before { sign_in homer, no_capybara: true }

		describe "submit GET to Users#edit on another user" do 
			before { get edit_user_path(moe) }
			specify { expect(response.body).not_to match(full_title('Edit User')) }
			specify { expect(response).to redirect_to(root_url) }
		end

		describe "submit PATCH to Users#update on another user" do 
			before { patch user_path(moe) }
			specify { expect(response).to redirect_to(root_url) }
		end

		# Ex 9.6.6 Signed in users should be redirected to root if they hit
		# User#new or User#create.
		describe 'submit GET to Users#new' do 
			before { get new_user_path }
			specify { expect(response).to redirect_to root_url }
		end

		describe 'submit POST to Users#create' do
			before { post users_path, { user:{ blah: 'blah'}} }
			specify { expect(response).to redirect_to root_url }
		end
	end
end