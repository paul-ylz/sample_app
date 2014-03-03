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


  describe 'password_reset' do 
  	let(:blinky) { create(:user, name: 'Blinky Three Eye') }
  	let(:mail) { blinky.send_password_reset }

	  subject { mail }

	  it 'renders the subject' do 
	  	mail.subject.should match('Password reset')
	  end

	  it 'renders the receiver email' do 
	  	mail.to.should == [blinky.email]
	  end

	  it 'renders the sender email' do 
	  	mail.from.should == ['noreply@sample_app.com']
	  end

	  it 'assigns @user' do 
	  	mail.body.encoded.should match(blinky.name)
	  end
  end


  describe 'email_confirmation' do 
  	let(:kent) { create(:unconfirmed_user, name: 'Kent Brockman') }
  	let(:mail) { kent.send_email_confirmation }

  	subject { mail }

	  it 'renders the subject' do 
	  	mail.subject.should match('Email confirmation')
	  end

	  it 'renders the receiver email' do 
	  	mail.to.should == [kent.email]
	  end

	  it 'renders the sender email' do 
	  	mail.from.should == ['noreply@sample_app.com']
	  end

	  it 'assigns @user' do 
	  	mail.body.encoded.should match(kent.name)
	  end

	end
end
