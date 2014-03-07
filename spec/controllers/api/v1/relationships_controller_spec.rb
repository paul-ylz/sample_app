require 'spec_helper'

module Api
	module V1 
		describe RelationshipsController do 
			render_views

			let(:homer) { create(:user, name: 'Homer Simpson') }
			let(:marge) { create(:user, name: 'Marge Simpson') }


			before do 
				homer.create_api_key
				marge.create_api_key
			end


			describe 'POST #create' do 

				it "should not create relationship without access token" do
					post :create, id: marge
					response.status.should eq 401
					marge.followers.should_not include homer
				end

				it "should create relationship with access token" do 
					set_http_authorization_header(homer)
					post :create, id: marge
					response.status.should eq 201
					marge.followers.should include homer
				end
			end


			describe 'DELETE #destroy' do 

				before do
					marge.follow!(homer)
				end

				it "should not destroy relationship without access token" do
					delete :destroy, id: homer
					response.status.should eq 401
				end

				it "should not allow anyone to delete a relationship except the follower" do 
					set_http_authorization_header(homer)
					delete :destroy, id: marge
					response.status.should eq 404
				end

				it "should let follower delete a relationship" do 
					set_http_authorization_header(marge)
					delete :destroy, id: homer
					response.status.should eq 200
				end
			end

		end
	end
end