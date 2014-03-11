require 'spec_helper'

describe 'Micropost pages' do 

	let(:mona) { create(:user, name: 'Mona Simpson') }
	let!(:m1) { create(:micropost, user: mona, content: 'How I wet your mother') }
	let!(:m2) { create(:micropost, user: mona, content: 'No disgrace like home') }

	subject { page } 

	describe "User's microposts are displayed on their profile" do 
		before { sign_in mona }
		it { should have_title mona.name }
		it { should have_selector 'h3', text: mona.microposts.count }
		it { should have_content(m1.content) }
		it { should have_content(m2.content) }
	end

	# Ex 10.5.4 Test visibility of delete links
	# 
	describe "User has delete links for their posts" do 
		before do 
			sign_in mona
			visit user_url mona 
		end
		it { should have_link('delete', href: micropost_path(m1)) }
	end

	describe "User should not have delete links for another user's posts" do 
		before do 
			sign_in create(:user, name: 'Grampa Simpson')
			visit user_url mona
		end
		it { should_not have_link('delete', href: micropost_path(m1)) }
	end


	describe "Micropost creation" do 
		before do 
			sign_in mona
			visit root_path 
		end

		describe "with invalid content" do 
			it "should not create micropost" do 
				expect{ click_button "Post" }.not_to change(Micropost, :count)
			end
			describe "should show error message" do
				before { click_button "Post" }
				it { should have_error_message }
			end
		end
		describe "with valid content" do 
			before { fill_in 'micropost_content', with: "Marry him Marge" }

			it "should create a micropost" do 
				expect { click_button 'Post' }.to change(Micropost, :count).by(1)
			end
		end
	end


	describe "Micropost destruction" do 
		describe "as correct user" do 
			before do 
				sign_in mona
				visit root_path 
			end
			it "should delete a micropost" do 
				expect { click_link "delete", match: :first }.to change(Micropost, :count).by(-1)
			end
		end
	end

	# Ex 10.5.2 Test micropost pagination
	# 
	describe "Pagination of microposts" do 
		before do 
			30.times do 
				create(:micropost, user: mona, content: 'Homer, your mother loves you.') 
			end
		end

		after { mona.microposts.delete_all }

		describe "on Mona's home page" do 
			before do 
				sign_in mona
				visit root_url 
			end
			# testing will_paginate is working
			# it { should have_selector('div.pagination') }
			# it "should list each feed item" do 
			# 	mona.feed.paginate(page: 1).each do |mp|
			# 		expect(page).to have_selector("li##{mp.id}", text: mp.content)
			# 	end
			# end

			# tests for kaminari pagination
			it { should have_selector('ul.pagination') }
			it "should list each feed item" do 
				mona.feed.page(1).each do |mp|
					expect(page).to have_selector("li##{mp.id}", text: mp.content)
				end
			end
		end

		describe "on Mona's profile page" do 
			before { visit user_url(mona) }
			# testing will_paginate
			# it { should have_selector('div.pagination') }
			# it "should list each of Mona's posts" do 
			# 	mona.microposts.paginate(page: 1).each do |mp|
			# 		expect(page).to have_selector("li##{mp.id}", text: mp.content)
			# 	end
			# end

			# tests for kaminari pagination
			it { should have_selector('ul.pagination') }
			it "should list each of Mona's posts" do 
				mona.microposts.page(1).each do |mp|
					expect(page).to have_selector("li##{mp.id}", text: mp.content)
				end
			end
		end
	end
end