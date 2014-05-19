require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ApplicationHelper. For example:
#
# describe ApplicationHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
describe ApplicationHelper do
  context "obscure_string" do
    it "should hide all but the last X digits" do
      expect(helper.obscure_string("123456789", 4)).to eq("*****6789")
      expect(helper.obscure_string("123456789", 1)).to eq("********9")
      expect(helper.obscure_string("123456789", 0)).to eq("*********")
      expect(helper.obscure_string("123456789", nil)).to eq("123456789")
      expect(helper.obscure_string("123456789", "")).to eq("123456789")
    end
  end
end