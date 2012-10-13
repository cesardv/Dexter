require 'test_helper'

class DropTest < ActiveSupport::TestCase

  test "find_by_id / create file drop" do
    attributes = {
      :id    => 'omg',
      :type => Drop::FILE
    }

    drop = Drop.create(attributes)
    assert_not_nil drop
    assert drop.is_a?(FileDrop)
    assert drop.valid?

    assert_equal Drop::FILE, drop.type

    drop = Drop.find_by_id('omg')
    assert_not_nil drop
    assert drop.is_a?(FileDrop)
  end

  test "find_by_id / create redirect" do
    attributes = {
      :id    => 'omg',
      :type => Drop::REDIRECT
    }

    drop = Drop.create(attributes)
    assert_not_nil drop
    assert drop.is_a?(Redirect)
    assert drop.valid?

    assert_equal Drop::REDIRECT, drop.type

    drop = Drop.find_by_id('omg')
    assert_not_nil drop
    assert drop.is_a?(Redirect)
  end

  test "validation error" do
    drop = Drop.create(:id => 'omg')
    assert drop.invalid?
    assert_nil Drop.find_by_id('omg')
  end


end
