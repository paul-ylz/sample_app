# http://blog.lucascaton.com.br/index.php/2010/10/25/how-to-test-mailers-in-rails-3-with-rspec/
require "spec_helper"

describe UserMailer do
  
	describe 'follower_notification' do 
	  let(:patty) { create(:user, name: 'Patty Bouvier') }
	  let(:selma) { create(:user, name: 'Selma Bouvier') }
	  let(:mail) { patty.send_follower_notification(selma) }

	  subject { mail }

	  it 'renders the subject' do 
	  	mail.subject.should match('new follower')
	  end

	  it 'renders the receiver email' do 
	  	mail.to.should == [patty.email]
	  end

	  it 'renders the sender email' do 
	  	mail.from.should == ['noreply@sample_app.com']
	  end

	  it 'assigns @followed' do 
	  	mail.body.encoded.should match(patty.name)
	  end

	  it 'assigns @follower' do 
	  	mail.body.encoded.should match(selma.name)
	  end
  end
end
