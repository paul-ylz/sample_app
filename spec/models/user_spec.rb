require 'spec_helper'

describe User do

	before do 
		@user = User.new(
			name: "Example User", 
			email: "user@example.com",
			password: "password",
			password_confirmation: "password"
			) 
	end

	subject { @user }

	it { should be_valid }

	it { should respond_to(:name) }
	it { should respond_to(:email) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:authenticate) }
	it { should respond_to(:remember_token) }

	describe "when name is not present" do 
		before { @user.name = "" }
		it { should_not be_valid }
	end

	describe "when email is not present" do 
		before { @user.email = "" }
		it { should_not be_valid }
	end

	describe "when name is too long" do 
		before { @user.name = "a" * 51 }
		it { should_not be_valid }
	end

	#  Ex 6.5.3 Rewrite the email validation regex so that foo@bar..com is invalid.
	describe "when email format is invalid" do 
		it "should be invalid" do 
			invalid_emails = %w(user@foo,com user_at_foo.org example.user@foo. 
				foo@bar_baz.com foo@bar+baz.com foo@bar..com)
			invalid_emails.each do |e|
				@user.email = e
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do 
		it "should be valid" do 
			valid_emails = %w(user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn)
			valid_emails.each do |e|
				@user.email = e
				expect(@user).to be_valid
			end
		end
	end

	# Note how the tests are @user centric, so we save the duplicate before 
	# testing that @user is invalid. We also test that email uniqueness is case 
	# insensitive.
	describe "when email is already taken" do 
		before do 
			duplicate = @user.dup
			duplicate.email.upcase!
			duplicate.save
		end

		it { should_not be_valid }
	end

	describe "when password is not present" do 
		before do 
			@user.password = ''
			@user.password_confirmation = ''
		end
		it { should_not be_valid }
	end

	describe "when password does not match confirmation" do 
		before { @user.password_confirmation = "mismatch" }
		it { should_not be_valid }
	end

	describe "when password is too short" do 
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { should be_invalid }
	end

	describe "return value of authenticate method" do 
		before { @user.save }
		let(:user) { User.find_by(email: @user.email) }
		
		describe "with valid password" do 
			it { should eq user.authenticate(@user.password) }
		end

		describe "with invalid password" do 
			it { should_not eq user.authenticate('bad_password') }
			specify { expect(user.authenticate('bad_password')).to be_false }
		end
	end

	# Ex 6.5.1 test that mixed case emails are saved in all lower case.
	describe "should downcase emails" do
		let(:mixed) { "fOo@bAr.coM" }
		before do
			@user.email = mixed
			@user.save
		end

		its(:email) { should eq mixed.downcase }
	end

	describe "remember_token" do 
		before { @user.save }		
		
		its(:remember_token) { should_not be_blank }
	end
end
