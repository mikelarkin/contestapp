# == Schema Information
#
# Table name: orders
#
#  id               :integer          not null, primary key
#  number           :string(255)
#  email            :string(255)
#  first_name       :string(255)
#  last_name        :string(255)
#  shopify_order_id :integer
#  order_date       :datetime
#  total            :float
#  line_item_count  :integer
#  financial_status :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#

require 'spec_helper'

describe Order do

  context "self.candidate_list(params)" do

    before do

      @product1 = FactoryGirl.create(:product)
      @product2 = FactoryGirl.create(:product)
      @product3 = FactoryGirl.create(:product)


      @order1 = FactoryGirl.create(:order, order_date: DateTime.now - 15.days)
      @order2 = FactoryGirl.create(:order, order_date: DateTime.now - 14.days)
      @order3 = FactoryGirl.create(:order, order_date: DateTime.now - 5.days)
      @order4 = FactoryGirl.create(:order, order_date: DateTime.now - 3.days)
      @order5 = FactoryGirl.create(:order, order_date: DateTime.now - 1.days)
      @order6 = FactoryGirl.create(:order, order_date: DateTime.now - 1.hour)

      @order_item1 = FactoryGirl.create(:order_item, shopify_product_id: @product1.shopify_product_id, order_id: @order1.id)
      @order_item2 = FactoryGirl.create(:order_item, shopify_product_id: @product1.shopify_product_id, order_id: @order2.id)
      @order_item3 = FactoryGirl.create(:order_item, shopify_product_id: @product1.shopify_product_id, order_id: @order3.id)
      @order_item4 = FactoryGirl.create(:order_item, shopify_product_id: @product2.shopify_product_id, order_id: @order4.id)
      @order_item5 = FactoryGirl.create(:order_item, shopify_product_id: @product2.shopify_product_id, order_id: @order5.id)
      @order_item6 = FactoryGirl.create(:order_item, shopify_product_id: @product1.shopify_product_id, order_id: @order6.id)
      @order_item7 = FactoryGirl.create(:order_item, shopify_product_id: @product2.shopify_product_id, order_id: @order6.id)

    end

    it "should return all orders if empty params are specified" do

      Order.candidate_list.should == [@order1.id,
                                      @order2.id,
                                      @order3.id,
                                      @order4.id,
                                      @order5.id,
                                      @order6.id]

    end

    it "should return orders sorted by order_date asc by default" do
      Order.candidate_list.should == [@order1.id,
                                      @order2.id,
                                      @order3.id,
                                      @order4.id,
                                      @order5.id,
                                      @order6.id]
    end

    it "should return orders sorted by the specified field" do
      Order.candidate_list(:sort => "order_date desc").should == [@order6.id,
                                                                  @order5.id,
                                                                  @order4.id,
                                                                  @order3.id,
                                                                  @order2.id,
                                                                  @order1.id]

    end

    it "should only return orders for a specific product" do
      Order.candidate_list(:product_id => @product2.shopify_product_id).should == [@order4.id,
                                                                                   @order5.id,
                                                                                   @order6.id]
    end

    it "should only return orders after a specific date" do
      Order.candidate_list(:start_date => DateTime.now - 6.days).should == [
        @order3.id,
        @order4.id,
        @order5.id,
      @order6.id]

    end

    it "should only return orders before a specific date" do
      Order.candidate_list(:end_date => DateTime.now - 6.days).should == [
        @order1.id,
      @order2.id]

    end

    it "should only return orders within a specific range" do

      Order.candidate_list(:start_date => DateTime.now - 5.days - 1.hour, :end_date => DateTime.now - 1.days + 1.hour).should == [
        @order3.id,
        @order4.id,
        @order5.id
      ]

    end

    it "should only return the specified number of orders" do
      Order.candidate_list(:max_results => 3).should == [@order1.id, @order2.id, @order3.id]

    end

    it "should only return the specified number of orders with the date range for a particular product in the specified order" do
      Order.candidate_list(:max_results => 1,
                           sort: "order_date desc",
                           start_date: DateTime.now - 2.days,
                           end_date: DateTime.now,
                           product_id: @product2.shopify_product_id).should == [@order6.id]
    end



  end

end
