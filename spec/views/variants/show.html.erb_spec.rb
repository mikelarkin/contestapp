require 'spec_helper'

describe "variants/show" do
  before(:each) do
    @variant = assign(:variant, stub_model(Variant,
      :product_id => 1,
      :shopify_variant_id => 2,
      :option1 => "Option1",
      :option2 => "Option2",
      :option3 => "Option3",
      :sku => "Sku",
      :barcode => "Barcode",
      :price => 1.5
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Option1/)
    rendered.should match(/Option2/)
    rendered.should match(/Option3/)
    rendered.should match(/Sku/)
    rendered.should match(/Barcode/)
    rendered.should match(/1.5/)
  end
end
