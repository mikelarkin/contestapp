# == Schema Information
#
# Table name: accounts
#
#  id                  :integer          not null, primary key
#  shopify_account_url :string(255)
#  shopify_password    :string(255)
#  created_at          :datetime
#  updated_at          :datetime
#  shopify_shop_id     :integer
#  shop_owner          :string(255)
#  email               :string(255)
#  shopify_shop_name   :string(255)
#  paid                :boolean          default(FALSE)

require 'spec_helper'

describe Account do
  before do
    @account = FactoryGirl.create(:account)
  end

  context "contests_run(start_date, end_date)" do
    it "should return the correct number of contests" do
        @contest1 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 5.days)
        @contest2 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 5.days)
        @contest3 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 4.days)
        @contest4 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 4.days)
        @contest5 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 3.days)
        @contest6 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 2.days)
        @contest7 = FactoryGirl.create(:contest, :account_id => @account.id, :created_at => DateTime.now - 1.days)

        @account.contests_run(DateTime.now - 5.days, DateTime.now).should == 7
        @account.contests_run(DateTime.now - 4.days, DateTime.now).should == 5
        @account.contests_run(DateTime.now - 1.days, DateTime.now).should == 1
        @account.contests_run(DateTime.now, DateTime.now).should == 0

    end
  end

  context "can_create_contests?" do
    it "should return true for paid accounts" do
      @account = FactoryGirl.create(:account, paid: true)
      @account.can_create_contests?.should be_true
    end

    it "should return true for paid accounts" do
      @account = FactoryGirl.create(:account, paid: true)
      @account.can_create_contests?.should be_true
    end

  end


end
