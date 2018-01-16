class Auction < ActiveRecord::Base
  belongs_to :product
  has_many :bids

  def top_bid
    bids.max_by(&:value)
  end

  def current_bid
    top_bid.nil? ? value : top_bid.value
  end

  def ended?
    ends_at < Time.now
  end

end
