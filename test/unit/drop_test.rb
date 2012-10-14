require 'test_helper'

class DropTest < ActiveSupport::TestCase
  should allow_value("hi").for(:id)
  should_not allow_value(nil).for(:id)
  should allow_value(Drop::FILE).for(:type)
  should_not allow_value(nil).for(:type)
  should_not allow_value("omg").for(:type)

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
      :id           => 'omg',
      :type         => Drop::REDIRECT,
      :redirect_url => mock_url
    }

    drop = Drop.create(attributes)
    assert_not_nil drop
    assert drop.is_a?(Redirect)
    assert drop.valid?

    assert_equal Drop::REDIRECT, drop.type

    drop = Drop.find_by_id('omg')
    assert_not_nil drop
    assert drop.is_a?(Redirect)
    assert_equal mock_url, drop.redirect_url
  end

  test "validation error doesn't store the item" do
    drop = Drop.create(:id => 'omg')
    assert drop.invalid?
    assert_nil Drop.find_by_id('omg')
  end

  test "id is already present when creating" do
    file = Drop.create(:id => 'omg', :type => Drop::FILE)
    assert file.valid?

    redirect = Drop.create(:id => 'omg', :type => Drop::REDIRECT)
    assert redirect.invalid?
    assert_equal ['already taken'], redirect.errors[:id]
    assert Drop.find_by_id('omg').is_a?(FileDrop)

  end


end
