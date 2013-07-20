require 'spec_helper'

describe User do
  subject(:user) { described_class.new }

  describe "#staff?" do
    subject { user.staff? }

    context "if staff status isn't present" do
      before { user.staff = nil }
      it { should be_false }
    end

    context "if #staff is false" do
      before { user.staff = false }
      it { should be_false }
    end

    context "if #staff is true" do
      before { user.staff = true }
      it { should be_true }
    end
  end

  describe "#shown_name" do
    pending "WRITE!"
  end

  describe "#promote!" do
    before do
      user.staff = false
    end

    it "promotes itself to staff" do
      expect { user.promote! } \
        .to change { user.staff? } \
        .from(false).to(true)
    end
  end

  describe "#demote!" do
    before do
      user.staff = true
    end

    it "demotes itself from staff" do
      expect { user.demote! } \
        .to change { user.staff? } \
        .from(true).to(false)
    end
  end

  after(:all) { User.destroy_all }
end
