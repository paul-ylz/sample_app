require 'spec_helper'

module Api
	module V1
		describe MicropostsController do 
			render_views

			let(:homer) { create(:user, name: 'Homer Simpson') }
			let(:marge) { create(:user, name: 'Marge Simpson') }
			
			before do 
				homer.create_api_key
				marge.create_api_key
			end

			describe "POST #create" do

				let(:json) do 
					{ format: 'json', micropost: { content: "Don't have a cow"} }
				end

				it "should not create without authentication" do 
					post :create, json
					response.status.should eq 401
				end

				it "should create with authentication" do 
					set_http_authorization_header(homer)
					post :create, json
					response.status.should eq 201
					JSON.parse(response.body)['id'].should eq Micropost.last.id
				end
			end


			describe "DELETE #destroy" do 

				let!(:homers_post) { create(:micropost, user: homer) }

				describe "without authorization" do 

					it "should not delete without authentication" do 
						delete :destroy, id: homers_post
						response.status.should eq 401
					end

					it "should not delete without authorization" do 
						set_http_authorization_header(marge)
						delete :destroy, id: homers_post
						response.status.should eq 401
					end

					it "should delete with correct authorization" do
						set_http_authorization_header(homer)
						delete :destroy, id: homers_post
						response.status.should eq 200
					end
				end
			end
		end
	end
end