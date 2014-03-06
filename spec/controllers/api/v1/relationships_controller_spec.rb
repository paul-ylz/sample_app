require 'spec_helper'

module Api
	module V1 
		describe RelationshipsController do 
			render_views

			describe 'POST #create' do 
				let(:homer) { create(:user, name: 'Homer Simpson') }
				let(:marge) { create(:user, name: 'Marge Simpson') }

				let(:json) {{ format: 'json', relationship: 
					{ follower_id: homer.to_param, followed_id: marge.to_param } } }

				before do 
					homer.create_api_key
					marge.create_api_key
				end

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
		end
	end
end