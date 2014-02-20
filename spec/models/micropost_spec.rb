require 'spec_helper'

describe Micropost do

	let(:seymour) { create(:user) }

	before do 
		@micropost = seymour.microposts.build(
			content: 'I know very little about children')
	end

	subject { @micropost }

	it { should respond_to(:content) }
	it { should respond_to(:user_id) }
	it { should be_valid }

	describe "should belong to user" do 
		it { should respond_to(:user) }
		its(:user) { should eq seymour }
	end

	describe "micropost validations" do 
		describe "when user_id is not present" do 
			before { @micropost.user_id = nil }
			it { should_not be_valid }
		end
		describe "when content is blank" do 
			before { @micropost.content = "" }
			it { should_not be_valid}
		end
		describe "when content is too long" do 
			before { @micropost.content = "a" * 141 }
			it { should_not be_valid }
		end
	end
	
	describe "user's microposts" do 
		let(:willie) { create(:user) }
		# Note that FactoryGirl allows us to set Rails' magic method created_at.
		# 
		let!(:older) { create(:micropost, user: willie, created_at: 1.day.ago) }
		let!(:newer) { create(:micropost, user: willie, created_at: 1.hour.ago) }
		
		it "should list microposts chronologically" do 
			expect(willie.microposts.to_a).to eq [newer, older]
		end
		it "should destroy associated microposts when a user is destroyed" do 
			microposts = willie.microposts.to_a
			willie.destroy
			expect(microposts).not_to be_empty
			microposts.each do |m|
				expect(Micropost.where(id: m.id)).to be_empty
			end
		end
	end
end