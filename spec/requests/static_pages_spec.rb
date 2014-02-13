require 'spec_helper'

describe "StaticPages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App |" }

  describe "Home page" do 
  	it "should have the content 'Sample App'" do
  		visit '/static_pages/home'
  		expect(page).to have_content('Sample App')
  	end
		
		# have_title checks the <title> tag contents. It will also match a substring.
  	it "should have the right title" do 
	  	visit '/static_pages/home'
	  	expect(page).to have_title("#{base_title} Home")
	  end
  end

  describe "Help page" do 
  	it "should have the content 'Help'" do 
  		visit '/static_pages/help'
  		expect(page).to have_content('Help')
  	end

  	it "should have the right title" do 
	  	visit '/static_pages/help'
	  	expect(page).to have_title("#{base_title} Help")
	  end
  end

  describe "About page" do 
  	it "should have the content 'About Us'" do 
  		visit '/static_pages/about'
  		expect(page).to have_content('About Us')
  	end

  	it "should have the right title" do 
	  	visit '/static_pages/about'
	  	expect(page).to have_title("#{base_title} About Us")
	  end
  end

  # Exercise 3.5.1 - Make a Contact page for the sample app. 
  describe "Contact page" do 
    it "should have the content 'Contact'" do 
      visit '/static_pages/contact'
      expect(page).to have_content('Contact')
    end

    it "should have the right title" do 
      visit '/static_pages/contact'
      expect(page).to have_title("Contact")
    end
  end
  
end
