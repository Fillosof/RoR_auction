require 'test_helper'
require "place_bid"
require 'database_cleaner'



class PlaceBidTest < MiniTest::Test

  def setup
    DatabaseCleaner.clean_with :truncation
    DatabaseCleaner.strategy = :transaction
    @user = User.create! email: "1@gmail.com", password: "123456789"
    @another_user = User.create! email: "2@gmail.com", password: "123456789"
    @product = Product.create! name: "Product", user_id: user.id
    @auction = Auction.create! value: 10, product_id: product.id
  end

  def test_it_places_a_bid
    service = PlaceBid.new(
        value: 11,
        user_id: another_user.id,
        auction_id: auction.id
    )

    service.execute

    assert_equal 11, auction.current_bid
  end

  def test_fails_to_place_bid_under_current_value
    service = PlaceBid.new(
        value: 9,
        user_id: another_user.id,
        auction_id: auction.id
    )

    refute service.execute, "Bid should not be place"

  end

  private

  attr_reader :user, :another_user, :auction, :product
end