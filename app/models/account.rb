class Account < ActiveRecord::Base
  validates_presence_of :shopify_account_url
  validates_presence_of :shopify_password

  has_many :orders, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :contests, :dependent => :destroy



  def contests_run(start_date, end_date)
    return self.contests.where([
                                 "contests.created_at >= ? AND contests.created_at <= ?",
                                 start_date.beginning_of_day,
                                 end_date.end_of_day
    ]).count
  end

  def can_create_contests?
    return true if self.paid?   # Paid Accounts have no limitations
    return (contests_run(DateTime.now - 1.month, DateTime.now) <
            MAX_CONTESTS_PER_MONTH)
  end

end
