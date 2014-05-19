describe ContestResults do
  context "initialize" do
    it "should raise exception if not an array" do
      expect {ContestResults.new([1])}.to_not raise_error
      expect {ContestResults.new([1,2,3,4])}.to_not raise_error
      expect {ContestResults.new(["a","b"])}.to_not raise_error
      expect {ContestResults.new("")}.to raise_error
      expect {ContestResults.new(nil)}.to raise_error
      expect {ContestResults.new([])}.to raise_error
      expect {ContestResults.new}.to raise_error
    end
  end
  context "results" do
    it "should return the proper results" do
      contest_results = ContestResults.new([1,2,3,4])
      contest_results.results.should be_a Integer
      contest_results.results(1).should be_a Integer
      contest_results.results(2).should be_a Array
      contest_results.results(0).should be_a Integer
      contest_results.results(nil).should be_a Integer
      contest_results = ContestResults.new(["a","b","c","d"])
      contest_results.results.should be_a String
      contest_results.results(1).should be_a String
      contest_results.results(2).should be_a Array
      contest_results.results(0).should be_a String
      contest_results.results(nil).should be_a String
    end
  end
end
