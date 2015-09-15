require 'spec_helper'

describe "orders/show" do
  before(:each) do
    @order = assign(:order, stub_model(Order,
      :number => "Number",
      :email => "Email",
      :first_name => "First Name",
      :last_name => "Last Name",
      :shopify_order_id => 1,
      :total => 1.5,
      :line_item_count => 2,
      :financial_status => "Financial Status"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/Number/)
    rendered.should match(/Email/)
    rendered.should match(/First Name/)
    rendered.should match(/Last Name/)
    rendered.should match(/1/)
    rendered.should match(/1.5/)
    rendered.should match(/Financial Status/)
  end
end
