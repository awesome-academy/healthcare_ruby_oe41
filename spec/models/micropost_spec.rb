require "rails_helper"

RSpec.describe Micropost, type: :model do
  describe "Associations" do
    it { should belong_to(:user) }
  end

  describe "validations" do
    it { should validate_presence_of(:content) }
    it { should validate_length_of(:content) }
  end
end
