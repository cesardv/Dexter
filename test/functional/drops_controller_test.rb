require 'test_helper'

class DropsControllerTest < ActionController::TestCase
  test "new" do
    get :new
    assert_response :success
  end
end
