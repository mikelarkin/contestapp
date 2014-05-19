class ContestResults
  def initialize(array)
    raise ArgumentError.new("array is required") if array.blank?
    @array = array
  end
  # Picks <count> winners
  def results(count=1)
    if count.to_i < 2
      @array.sample
    else
      @array.sample(count)
    end
  end
end
