require "rails_helper"

RSpec.describe User, type: :model do
  let!(:user) {FactoryBot.create(:user)}

  describe "Associations" do
    it { should have_many(:microposts).dependent(:destroy) }
    it { should have_many(:active_relationships).dependent(:destroy) }
    it { should have_many(:passive_relationships).dependent(:destroy) }
    it { should have_many(:following) }
    it { should have_many(:followers) }
  end

  describe "validations" do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name) }

    it { should validate_presence_of(:email) }
    it { should validate_length_of(:email) }
    it { should allow_value("email@email.com").for(:email) }
    it { should_not allow_value("hello").for(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password) }
    it { should have_secure_password(:password) }
  end

  describe "function" do
    it "function following?" do
      User.first.follow user unless User.first.following.include? user
      expect(User.first.following? user).to eq(User.first.following.include? user)
    end

    it "function feed" do
      actual = Micropost.where_user_id(User.first.following_ids << User.first.id).recent_posts
      expect(User.first.feed).to match_array(actual)
    end

    it "function follow" do
      User.first.follow user unless User.first.following? user
      expect(User.first.following).to include(user)
    end

    it "function unfollow" do
      User.first.follow user unless User.first.following? user
      User.first.unfollow user
      expect(User.first.following).to_not include(user)
    end

    
    it "function downcase_email" do
      user.email = "Email@EmAiL.com"
      expect(user.send(:downcase_email)).to eq "Email@EmAiL.com".downcase
    end
  end

end
