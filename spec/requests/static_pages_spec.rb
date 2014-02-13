require 'spec_helper'

describe "StaticPages" do

  # Exercise 3.5.2 Refactor title test using Rspec's 'let' helper method.
  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

  subject { page }

  describe "Home page" do 
    before { visit root_path }

		it { should have_content('Sample App') } 
		
		# have_title checks the <title> tag contents. It will also match a substring.
  	it { should have_title("#{base_title}") }

    it { should_not have_title('| Home') }
  end

  describe "Help page" do 
    before { visit help_path }
    
    it { should have_content('Help') }

    it { should have_title("#{base_title} | Help") }
  end

  describe "About page" do 
    before { visit about_path }
    
    it { should have_content('About Us') }

    it { should have_title("#{base_title} | About Us") }
  end

  # Exercise 3.5.1 - Make a Contact page for the sample app. 
  describe "Contact page" do 
    before { visit contact_path }
    
    it { should have_content('Contact') }

    it { should have_title("Contact") }
  end
  
end
