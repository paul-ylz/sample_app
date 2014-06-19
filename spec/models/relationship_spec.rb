require 'spec_helper'

describe Relationship do

  let(:homer) { create(:user, name: 'Homer Simpson') }
  let(:marge) { create(:user, name: 'Marge Simpson') }
  let(:rel) { marge.relationships.build(followed_id: homer.id) }

  subject { rel }

  describe "associations" do
    it { should respond_to(:follower_id) }
    it { should respond_to(:followed_id) }
    its(:follower) { should eq marge }
    its(:followed) { should eq homer }
  end

  describe "validations" do
    describe "followed_id not present" do
      before { rel.followed_id = nil }
      it { should_not be_valid }
    end
    describe "follower_id not present" do
      before { rel.follower_id = nil }
      it { should_not be_valid }
    end
  end
end
