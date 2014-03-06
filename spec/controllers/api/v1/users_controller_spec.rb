require 'spec_helper'

module Api
	module V1
		describe UsersController do 
			render_views

			before { request.accept = "application/json" }

			describe 'POST #create' do 
				let(:homer) { build(:user, name: 'Homer Simpson') }
				let(:json) { 
										{ format: 'json', 
											user: 
											{ name: homer.name, 
												username: homer.username, 
												email: homer.email, 
												password: homer.password, 
												password_confirmation: homer.password
											} 
										}
									}

				it "should create" do 
					expect { post :create, json }.to change(User, :count).by(1)
					response.status.should eq 201
					body = JSON.parse(response.body)
					body['id'].should eq User.last.id
					body['email'].should eq homer.email
				end
			end


			describe 'GET #index' do 
				before { 3.times{ create(:user) } }
				describe 'without token' do 
					
					it "should return 401 unauthorized" do 
						get :index
						response.status.should eq 401
					end
				end

				describe 'with token' do 
					let(:homer) { create(:user, name: 'Homer Simpson') }

					before { homer.create_api_key! }

					it "should return user index" do 
						set_http_authorization_header(homer)
						get :index
						response.status.should eq 200
						# should list homer and 3 created users
						JSON.parse(response.body).length.should eq 4
					end
				end
			end


			describe 'GET #show' do 
				let!(:santa) { create(:user, name: 'Santas little helper') }

				it "should show a single user to anybody" do 
					get :show, id: santa
					response.status.should eq 200
					body = JSON.parse(response.body)
					body['id'].should eq santa.id
					body['email'].should eq santa.email
				end
			end


			describe 'PATCH #update' do 
				let(:bart) { create(:user, name: 'Bart Simpson') }
				let(:marge) { create(:user, name: 'Marge Simpson') }
				
				before do 
					bart.create_api_key
					marge.create_api_key
				end

				it "should not let anonymous request update marge's particulars" do 
					patch :update, id: marge, user: { email: 'new@for.marge.com' }
					response.status.should eq 401
				end				

				it "should not let bart update marge's particulars" do 
					set_http_authorization_header(bart)
					patch :update, id: marge, user: { email: 'new@for.marge.com' }
					response.status.should eq 401
				end

				it "should let marge update her particulars" do 
					set_http_authorization_header(marge)
					patch :update, id: marge, user: { email: 'new@for.marge.com' }
					response.status.should eq 200
					JSON.parse(response.body)['email'].should eq 'new@for.marge.com'
				end
			end


			describe 'DELETE #destroy' do 
				let(:bart) { create(:user, name: 'Bart Simpson') }
				let!(:marge) { create(:user, name: 'Marge Simpson') }
				let(:admin) { create(:admin) }

				before do 
					bart.create_api_key
					admin.create_api_key
				end

				it "should not let anonymous users delete users" do 
					delete :destroy, id: marge
					response.status.should eq 401
				end

				it "should not let bart delete marge" do 
					set_http_authorization_header(bart)
					delete :destroy, id: marge
					response.status.should eq 401
				end

				it "should let admin delete a user" do 
					set_http_authorization_header(admin)
					expect { delete :destroy, id: marge }.to change(User, :count).by(-1)
					response.status.should eq 200
				end
			end


			describe 'GET #following' do 
				let(:homer) { create(:user, name: 'Homer Simpson') }
				let(:marge) { create(:user, name: 'Marge Simpson') }
				let(:bart) { create(:user, name: 'Bart Simpson') }

				before do 
					homer.create_api_key 
					bart.follow!(marge)
					bart.follow!(homer)
				end

				it "should not let anonymous users retrieve list of following" do 
					get :following, id: bart
					response.status.should eq 401
				end

				it "should display list of following" do 
					set_http_authorization_header(homer)
					get :following, id: bart 
					response.status.should eq 200
					JSON.parse(response.body).length.should eq 2
				end
			end


			describe 'GET #followers' do 
				let(:homer) { create(:user, name: 'Homer Simpson') }
				let(:marge) { create(:user, name: 'Marge Simpson') }
				let(:bart) { create(:user, name: 'Bart Simpson') }

				before do 
					homer.create_api_key 
					marge.follow!(bart)
					homer.follow!(bart)
				end

				it "should not let anonymous users retrieve list of followers" do 
					get :followers, id: bart
					response.status.should eq 401
				end

				it "should display list of followers" do 
					set_http_authorization_header(homer)
					get :followers, id: bart 
					response.status.should eq 200
					JSON.parse(response.body).length.should eq 2
				end
			end

		end
	end
end