require 'spec_helper'

describe User do

	let(:user) { build(:user) }
	
	subject { user }

	it { should be_valid }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:microposts) }
	it { should respond_to(:feed) }
	it { should respond_to(:relationships) }
	it { should respond_to(:followed_users) }
	it { should respond_to(:following?) }
	it { should respond_to(:follow!) }
	it { should respond_to(:unfollow!) }
	it { should respond_to(:reverse_relationships) }
	it { should respond_to(:followers) }
	it { should respond_to(:username) }
	it { should respond_to(:messages) }
	it { should respond_to(:received_messages) }
	it { should respond_to(:notifications) }

	describe "when name is not present" do 
		before { user.name = "" }
		it { should_not be_valid }
	end

	describe "when email is not present" do 
		before { user.email = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do 
		before { user.name = "a" * 51 }
		it { should_not be_valid }
	end

	#  Ex 6.5.3 Rewrite the email validation regex so that foo@bar..com is invalid.
	describe "when email format is invalid" do 
		it "should be invalid" do 
			invalid_emails = %w(user@foo,com user_at_foo.org example.user@foo. 
				foo@bar_baz.com foo@bar+baz.com foo@bar..com)
			invalid_emails.each do |e|
				user.email = e
				expect(user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do 
		it "should be valid" do 
			valid_emails = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
			valid_emails.each do |e|
				user.email = e
				expect(user).to be_valid
			end
		end
	end

	# Note how the tests are user centric, so we save the duplicate before 
	# testing that user is invalid. We also test that email uniqueness is case 
	# insensitive.
	describe "when email is already taken" do 
		before { user.save! }
		let(:dupe) { User.new(email: user.email) }
		specify { expect(dupe).not_to be_valid }
	end

	describe "when password is not present" do 
		before { user.password = user.password_confirmation = '' }
		it { should_not be_valid }
	end

	describe "when password does not match confirmation" do 
		before { user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password is too short" do 
		before { user.password = user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do 
		before { user.save! }
		let(:lookup) { User.find_by(email: user.email) }
		
		describe "with valid password" do 
			specify { expect(lookup).to eq user.authenticate(user.password) }
		end

		describe "with invalid password" do 
			specify { expect(lookup).not_to eq user.authenticate('wrong_password') }
			specify { expect(user.authenticate('wrong_password')).to be_false }
		end
	end

	# Ex 6.5.1 test that mixed case emails are saved in all lower case.
	# 
	describe "should downcase emails" do
		let(:mixed) { "fOo@bAr.coM" }
		before do
			user.email = mixed
			user.save!
		end
		its(:email) { should eq mixed.downcase }
	end


	describe "username validations" do 
		let(:homer) { build(:user, name: 'Homer Simpson') }
		subject { homer }

		describe "when empty" do 
			before { homer.username = "" }
			it { should_not be_valid }
		end
		describe "when too long" do 
			before { homer.username = "a" * 16 }
			it { should_not be_valid }
		end
		describe "when not unique" do 
			let(:copycat) { build(:user, username: homer.username) }
			before { homer.save! }
			specify { expect(copycat).not_to be_valid }
		end
		describe "when it contains invalid characters" do 
			it "should be invalid" do 
				invalid_usernames = ['!noexclaim', 'no space', '{"symbols']
				invalid_usernames.each do |e|
					homer.username = e
					expect(homer).not_to be_valid
				end
			end
		end	
	end


	describe "remember_token" do 
		before { user.save }		
		its(:remember_token) { should_not be_blank }
	end

	describe "administrator" do 
		it { should_not be_admin }
		describe "with admin attribute set to true" do 
			before do 
				user.save!
				# Chap 9.38 use toggle! to switch a boolean attribute
				user.toggle!(:admin)
			end
			it { should be_admin }
		end
	end

	describe "micropost associations" do 
		let(:user) { create(:user) }
		
		let!(:m1) { create(:micropost, user: user) }
		let!(:m2) { create(:micropost, user: user) }
		let!(:m3) { create(:micropost, user: create(:user)) }

		describe "feed should include user's posts" do 
			its(:feed) { should include m1 }
			its(:feed) { should include m2 }
		end

		describe "feed should not include unfollowed users' posts" do 
			its(:feed) { should_not include m3 }
		end

		describe "feed should include followed users' posts" do 
			let(:followed_user) { create(:user) }
			before do 
				user.follow!(followed_user)
				3.times { followed_user.microposts.create!(content: 'Foo!') }
			end
			its(:feed) do 
				followed_user.microposts.each do |micropost|
					should include(micropost)
				end
			end
		end

		it "should destroy associated microposts when a user is destroyed" do 
			microposts = user.microposts.to_a
			user.destroy
			expect(microposts).not_to be_empty
			microposts.each do |m|
				expect(Micropost.where(id: m.id)).to be_empty
			end
		end
	end

	# Chap 11
	describe "relationship associations" do 
		let(:marge) { create(:user, name: 'Marge Simpson') }
		let(:homer) { create(:user, name: 'Homer Simpson') }
		
		before { marge.follow! homer }

		subject { marge }

		it { should be_following homer }
		its(:followed_users) { should include homer }

		describe "followed user" do 
			subject { homer }
			its(:followers) { should include marge }
		end
		
		describe "and unfollowing" do 
			before { marge.unfollow! homer }
			it { should_not be_following homer }
			its(:followed_users) { should_not include homer }
		end

		# Exercise 11.5.1 Tests for destroying asociated relationships
		it "should destroy relationships when a user is destroyed" do 
			relationships = Relationship.where(follower_id: marge.to_param).to_a
			marge.destroy 
			expect(relationships).not_to be_empty
			relationships.each do |r|
				expect(Relationship.where(id: r.id)).to be_empty
			end
		end
	end
end
