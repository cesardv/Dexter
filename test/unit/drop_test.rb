require 'test_helper'

class DropTest < ActiveSupport::TestCase
  test "find_by_id / create" do
    attributes = {
      :id    => 'omg',
      :type => Drop::FILE
    }

    drop = Drop.create(attributes)
    assert_not_nil drop

    assert_equal Drop::FILE, drop.type
  end

end
