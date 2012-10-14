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


  test "break into sections" do
    Timecop.freeze(Time.now) do
      times = []
      10.times do
        times << Time.now
      end

      20.times do
        times << Time.now + 11.hours
      end

      30.times  do
        times << Time.now + 22.hours
      end

      sections = Stats.break(times, Time.now, Time.now + 1.day, 3)

      assert_equal [10, 20, 30], sections
    end
  end

end
