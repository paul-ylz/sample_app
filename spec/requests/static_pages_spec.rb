require 'spec_helper'

describe "StaticPages" do

  subject { page }

  # Exercise 3.5.2 Refactor title test using Rspec's 'let' helper method.
  # let(:base_title) { "Ruby on Rails Tutorial Sample App" }
  # re-refactored in chapter 5 with full_title() in spec_helper

  # Ex 5.6.2 Refactor to use Rspec's shared_examples_for
  shared_examples_for 'all static pages' do 
    it { should have_selector('h1', text: heading) } 
    # have_title checks <title> tag contents. It will also match a substring.
    it { should have_title(full_title(page_title)) }
  end

  describe "Home page" do 
    
    describe "for unauthenticated users" do 
      before { visit root_path }
      let(:heading) { 'Sample App' }    
      let(:page_title) { '' }
      it_should_behave_like "all static pages"
      # Do not want 'Home' to show up on home page.
      it { should_not have_title('| Home') }
    end
    
    describe "for authenticated users" do 
      let(:maggie) { create(:user, name: 'Maggie Simpson') }
      
      describe "should render Maggie's feed" do 
        before do 
          create(:micropost, user: maggie, content: 'click click')
          create(:micropost, user: maggie, content: "It's your fault I can't talk")
          sign_in maggie 
          visit root_path
        end

        it "should render Maggie's feed" do 
          maggie.feed.each do |item|
            expect(page).to have_selector("li##{item.id}", text: item.content)
          end
        end
      end
      
      # Ex 10.5.1 Tests for sidebar micropost counts with proper pluralization
      describe "sidebar micropost count" do 
        let(:burns) { create(:user, name: 'Charles Montgomery Burns') }
        before { sign_in burns }

        describe "with 0 microposts" do 
          before { visit root_path }
          it { should have_content('0 microposts') }
        end

        describe "with 1 micropost" do 
          before do 
            create(:micropost, user: burns, content: 'Smithers!')
            visit root_path
          end
          it { should have_content('1 micropost') }
        end
        
        describe "correct pluralization" do
          before do 
            create(:micropost, user: burns, content: 'Smithers!')
            create(:micropost, user: burns, content: "Don't make me call twice")
            visit root_path
          end
          it { should have_selector('span.count', text: /\A2 microposts\z/) }
        end
      end

      describe "follower and following counts" do 
        let(:snowball) { create(:user, name: 'Snowball the cat') }
        before do 
          snowball.follow!(maggie)
          sign_in maggie
          visit root_path
        end

        it { should have_link("0 following", href: following_user_path(maggie)) }
        # TODO: pluralize for stats
        it { should have_link("1 followers", href: followers_user_path(maggie)) }
      end

    end
  end

  describe "Help page" do 
    before { visit help_path }
    let(:heading) { 'Help' }    
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end

  describe "About page" do 
    before { visit about_path }
    let(:heading) { 'About Us' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"

  end

  # Exercise 3.5.1 - Make a Contact page. 
  describe "Contact page" do 
    before { visit contact_path }
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  # Exercise 5.6.3 test that layout links are properly defined
  it "layout has the correct links" do 
    visit root_path
    
    click_link "Sign up now!" 
    current_path.should == signup_path

    click_link "Home"
    current_path.should == root_path

    click_link "Help"
    current_path.should == help_path

    click_link "About"
    current_path.should == about_path
    
    click_link "Contact"
    current_path.should == contact_path
  end
  
end
