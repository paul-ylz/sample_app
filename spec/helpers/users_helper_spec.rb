require 'spec_helper'
# include UsersHelper

describe UsersHelper do 

	# Ex 7.6.1 Testing that gravatar_for will take a size parameter.
	describe 'gravatar_for' do 
		let(:user) { create(:user) } 
		
		it "should specify a default size for gravatar url" do 
			gravatar_for(user).should =~ /s=50/
		end

		it "should accept optional size parameter" do 
			gravatar_for(user, size: 40).should =~ /s=40/
		end
	end

end