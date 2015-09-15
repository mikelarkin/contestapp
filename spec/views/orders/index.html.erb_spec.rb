require 'spec_helper'

describe "orders/index" do
  before(:each) do
    assign(:orders, [
      stub_model(Order,
        :number => "Number",
        :email => "Email",
        :first_name => "First Name",
        :last_name => "Last Name",
        :shopify_order_id => 1,
        :total => 1.5,
        :line_item_count => 2,
        :financial_status => "Financial Status",
        :created_at => DateTime.now
      ),
      stub_model(Order,
        :number => "Number",
        :email => "Email",
        :first_name => "First Name",
        :last_name => "Last Name",
        :shopify_order_id => 1,
        :total => 1.5,
        :line_item_count => 2,
        :financial_status => "Financial Status",
        :created_at => DateTime.now
      )
    ])
  end

  it "renders a list of orders" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "First Name".to_s, :count => 2
    assert_select "tr>td", :text => "Last Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
    assert_select "tr>td", :text => "Financial Status".to_s, :count => 2
  end
end
