require 'spec_helper'

describe "Variants" do
  describe "GET /variants" do
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get variants_path
      response.status.should be(200)
    end
  end
end
