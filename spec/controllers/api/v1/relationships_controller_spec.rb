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
				let(:json) {{ format: 'json', relationship: 
					{ follower_id: homer.to_param, followed_id: marge.to_param } } }

				it "should not let anonymous users create relationship" do
					post :create, json
					response.status.should eq 401
				end

				it "should not allow anyone to create a following except the follower" do 
					set_http_authorization_header(marge)
					post :create, json
					response.status.should eq 401
				end

				it "should let follower create following" do 
					set_http_authorization_header(homer)
					post :create, json
					response.status.should eq 201
				end
			end


			describe 'DELETE #destroy' do 

				before do
					marge.follow!(homer)
				end

				it "should not let anonymous users delete a relationship" do
					delete :destroy, id: Relationship.last.to_param 
					response.status.should eq 401
				end

				it "should not allow anyone to delete a relationship except the follower" do 
					set_http_authorization_header(homer)
					delete :destroy, id: Relationship.last.to_param 
					response.status.should eq 401
				end

				it "should let follower delete a relationship" do 
					set_http_authorization_header(marge)
					delete :destroy, id: Relationship.last.to_param 
					response.status.should eq 200
				end
			end

		end
	end
end