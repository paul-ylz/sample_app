require 'spec_helper'

describe 'Message pages' do 
  let(:homer) { create(:user, name: 'Homer Simpson') }
  let(:marge) { create(:user, name: 'Marge Simpson') }
  let(:bart) { create(:user, name: 'Bart Simpson') }
  let(:lisa) { create(:user, name: 'Lisa Simpson') }

  subject { page }


  describe "reading a message" do 
  	let!(:message) { homer.messages.create(to: bart.id, 
  			content: "Bart, with $10,000, we'd be millionaires!") }

  	before do 
  		sign_in bart
  		click_link 'Messages'
  		click_link 'read', href: message_path(message)
  	end

  	it { should have_content message.content }
    it { should have_link 'delete' }

    it "should delete a message" do 
      expect { click_link 'delete' }.to change(Message, :count).by(-1)
    end
  end


  describe "message index should list messages, senders and delete links" do 
    let!(:m1) { homer.messages.create(to: lisa.id, content: 'foo bar') }
    let!(:m2) { marge.messages.create(to: lisa.id, content: 'foo baz') }

    before do 
      sign_in lisa 
      click_link 'Messages'
    end

    it { should have_content m1.sender.name }
    it { should have_content m2.sender.name }

    it { should have_link 'read', href: message_path(m1) }
    it { should have_link 'read', href: message_path(m2) }

    it { should have_link 'delete', href: message_path(m1) }
    it { should have_link 'delete', href: message_path(m2) }
    
    it "should delete a message" do 
      expect { click_link 'delete', match: :first }.to change(Message, :count).by(-1)
    end
  end


  describe "sending messages" do 
    before do 
      sign_in homer
      visit root_url
      fill_in 'micropost_content', with: "d #{bart.username} Son, when you 
        participate in sporting events, it's not whether you win or lose: it's 
        how drunk you get."
    end

    it "should create a message" do 
      expect{ click_button 'Post' }.to change(Message, :count).by(1)
    end

    it "should not create a micropost" do 
      expect{ click_button 'Post' }.not_to change(Micropost, :count).by(1)
    end
  end


  describe "reply messages" do 
    let!(:message) { bart.messages.create(to: lisa.id, content: "Lisa is stupid") }
    before do 
      sign_in lisa
      click_link 'Messages'
      click_link 'read', href: message_path(message)
      click_link 'reply'
      fill_in 'message_content', with: 'So is bart'
    end

    it "should create a reply message" do 
      expect { click_button 'Send' }.to change(Message, :count).by(1)
    end
  end


  describe "sent messages" do 
    let!(:message) { marge.messages.create(to: bart.id, 
      content: "Bart, clean your room.") }
    before do 
      sign_in marge
      click_link 'Messages'
      click_link 'Sent messages'
    end

    it { should have_title 'Sent messages' }
    it { should have_content "#{bart.name}" }
  end

  describe "authorizations" do 
    let!(:message) { marge.messages.create(to: bart.id, 
      content: "Bart, clean your room.") }

    describe "as unauthenticated user" do 

      shared_examples_for "redirects to signin" do 
        specify { expect(response).to redirect_to signin_url }
      end

      describe "inbox" do 
        before { get messages_path }
        it_should_behave_like "redirects to signin"
      end

      describe "reading a message" do 
        before { get message_path message }
        it_should_behave_like "redirects to signin"
      end

      describe "sent messages" do 
        before { get sent_messages_path }
        it_should_behave_like "redirects to signin"
      end

      describe "deleting a message" do 
        specify { expect { delete message_path message }.not_to change(Message, :count).by(-1) }

        before { delete message_path message }
        it_should_behave_like "redirects to signin"
      end
    end

    describe "as wrong user" do 
      before { sign_in homer, no_capybara: true }

      describe "deleting another user's message" do 
        specify { expect { delete message_path message }.not_to change(Message, :count).by(-1) }

        describe "it should redirect to root" do 
          before { delete message_path message }
          specify { expect(response).to redirect_to root_url }
        end
      end

      describe "reading another user's message" do 
        before { get message_path message }
        specify { expect(response).to redirect_to root_url }
      end
    end
  end
end