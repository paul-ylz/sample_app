require 'spec_helper'

describe "Authentication" do

	subject { page }

	describe "signin page" do 
		before { visit signin_path }
		it { should have_title 'Sign in' }

		describe "sign in with invalid information" do 
		before { click_button "Sign in" }
		it { should have_title 'Sign in' }
		it { should have_error_message 'Invalid' }

			# Test for persistence of flash error message. The issue is that flash 
			# messages persist for 1 request. However, we render 'new' with invalid 
			# login, which unlike 'redirect_to', does not count as a request.
			describe "and after visiting another page" do
				before { click_link "Home" }
				it { should_not have_error_message }
			end
		end

		describe "sign in with valid information" do 
			let(:user) { create(:user) }
			before { sign_in user }
			it { should have_signed_in_links user }
			it { should_not have_link 'Sign in', href: signin_path }

			describe "followed by signout" do 
				before { click_link "Sign out" }
				it { should have_link 'Sign in' }
				# Ex 9.6.3 check that signed out user no longer sees signed in links
				it { should_not have_signed_in_links user }
			end
		end
	end # signin page

	describe "authorization" do 

		describe "for non signed in users" do 
			let(:moe) { create(:user) }

			describe "visiting the edit page" do 
				before { visit edit_user_path(moe) }
				specify { expect(current_path).to eq signin_path }
		
				# Test for friendly forwarding
				describe "should then redirect to edit page after user has signed in" do 
					before do 
						visit edit_user_path(moe)
						# should redirect to signin_path
						fill_in "Email", with: moe.email
						fill_in "Password", with: moe.password
						click_button "Sign in"
					end
					it "should render the protected page" do 
						expect(current_path).to eq edit_user_path(moe)
					end

					describe "but revert to default on subsequent signin" do 
						before do
							click_link "Sign out"
							sign_in moe
						end
						it "should render show user page" do 
							expect(current_path).to eq user_path(moe)
						end
					end
				end
			end

			describe "submitting to the update action" do 
				before { patch user_path moe }
				specify { expect(response).to redirect_to signin_path }
			end

			describe "visiting the user index" do 
				before { get users_path }
				specify { expect(response).to redirect_to signin_path }
			end
		end

		describe "for wrong users" do 
			let(:ned) { create(:user) }
			let(:homer) { create(:user, email: "naughty@user.com") }
			# Chap 9.2.2 We cannot use capybara for these tests because a user would
			# not be able to access these routes via browser links. 
			before { sign_in homer, no_capybara: true }

			describe "submit GET to User#edit" do 
				before { get edit_user_path(ned) }
				specify { expect(response.body).not_to match(full_title('Edit User')) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "submit PATCH to Users#update" do 
				before { patch user_path(ned) }
				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "for non admin users" do 
			let(:bart) { create(:user) }
			let(:lisa) { create(:user) }
			before { sign_in bart, no_capybara: true }

			describe "submit DELETE to Users#destroy" do 
				before { delete user_path(lisa) }
				specify { expect(response).to redirect_to(root_path) }
			end
		end

		# Ex 9.6.1 Testing that a user cannot change admin attribute
		describe "admin attribute cannot be edited from web" do 
			let(:ralph) { create(:user) }
			let(:params) do 
				{ user: 
					{
					admin: true,
					password: ralph.password,
					password_confirmation: ralph.password
					}
				}
			end
			before do 
				sign_in ralph, no_capybara: true
				patch user_path ralph, params
			end
			specify { expect(ralph.reload.admin).to eq false }
		end
	end # authorization

	# Ex 9.6.6 Signed in users should be redirected to root if they hit
	# User#new or User#create.
	describe "signed in users should not create users" do 
		let(:martin) { create(:user) }
		before { sign_in martin, no_capybara: true }
		
		describe 'when Martin gets users#new' do 
			before { get new_user_path }
			specify { expect(response).to redirect_to root_url }
		end

		describe 'when Martin posts to users#create' do
			before { post users_path, { user:{ blah: 'blah'}} }
			specify { expect(response).to redirect_to root_url }
		end
	end

end

