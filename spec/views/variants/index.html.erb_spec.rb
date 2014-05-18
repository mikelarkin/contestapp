require 'spec_helper'

describe "variants/index" do
  before(:each) do
    assign(:variants, [
      stub_model(Variant,
        :product_id => 1,
        :shopify_variant_id => 2,
        :option1 => "Option1",
        :option2 => "Option2",
        :option3 => "Option3",
        :sku => "Sku",
        :barcode => "Barcode",
        :price => 1.5,
        :created_at => DateTime.now
      ),
      stub_model(Variant,
        :product_id => 1,
        :shopify_variant_id => 2,
        :option1 => "Option1",
        :option2 => "Option2",
        :option3 => "Option3",
        :sku => "Sku",
        :barcode => "Barcode",
        :price => 1.5,
        :created_at => DateTime.now
      )
    ])
  end

  it "renders a list of variants" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Option1".to_s, :count => 2
    assert_select "tr>td", :text => "Option2".to_s, :count => 2
    assert_select "tr>td", :text => "Option3".to_s, :count => 2
    assert_select "tr>td", :text => "Sku".to_s, :count => 2
    assert_select "tr>td", :text => "Barcode".to_s, :count => 2
    assert_select "tr>td", :text => 1.5.to_s, :count => 2
  end
end
