require 'test_helper'

class StatsTest < ActiveSupport::TestCase

  test "request stat attributes" do
    request_stats = Stats::Request.new(chrome_user_agent)

    expected = {
      :user_agent => chrome_user_agent,
      :mobile     => false,
      :computer   => true,
      :bot        => false
    }

    assert_equal expected, request_stats.attributes
  end

end
