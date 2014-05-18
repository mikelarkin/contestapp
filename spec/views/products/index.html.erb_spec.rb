require 'spec_helper'

describe "products/index" do
  before(:each) do
    assign(:products, [
      stub_model(Product,
        :name => "Name",
        :shopify_product_id => 1,
        :created_at => DateTime.now
      ),
      stub_model(Product,
        :name => "Name",
        :shopify_product_id => 1,
        :created_at => DateTime.now
      )
    ])
  end

  it "renders a list of products" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
  end
end
