require 'spec_helper'

describe "variants/new" do
  before(:each) do
    assign(:variant, stub_model(Variant,
      :product_id => 1,
      :shopify_variant_id => 1,
      :option1 => "MyString",
      :option2 => "MyString",
      :option3 => "MyString",
      :sku => "MyString",
      :barcode => "MyString",
      :price => 1.5
    ).as_new_record)
  end

  it "renders new variant form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form[action=?][method=?]", variants_path, "post" do
      assert_select "input#variant_product_id[name=?]", "variant[product_id]"
      assert_select "input#variant_shopify_variant_id[name=?]", "variant[shopify_variant_id]"
      assert_select "input#variant_option1[name=?]", "variant[option1]"
      assert_select "input#variant_option2[name=?]", "variant[option2]"
      assert_select "input#variant_option3[name=?]", "variant[option3]"
      assert_select "input#variant_sku[name=?]", "variant[sku]"
      assert_select "input#variant_barcode[name=?]", "variant[barcode]"
      assert_select "input#variant_price[name=?]", "variant[price]"
    end
  end
end
