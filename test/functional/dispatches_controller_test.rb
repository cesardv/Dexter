require 'test_helper'

class DispatchesControllerTest < ActionController::TestCase

  test "redirection dispatches as expected" do
    drop = Drop.create(
      :id => 'omg/lol',
      :type => Drop::REDIRECT,
      :redirect_url => mock_url
    )

    get :show, :id => 'omg/lol'
    assert_redirected_to mock_url
  end

  test "dispatch not found" do
    get :show, :id => 'omg'
    assert_response :not_found
  end

  test "dispatch file" do
    drop = Drop.create(
      :id   => 'omg/lol',
      :type => Drop::FILE,
      :file => mock_file
    )

    get :show, :id => 'omg/lol'
    assert_response :success
  end

end
