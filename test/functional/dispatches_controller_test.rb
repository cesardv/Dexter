require 'test_helper'

class DispatchesControllerTest < ActionController::TestCase

  test "redirection dispatches as expected" do
    drop = Drop.create(
      :id => 'omg/lol',
      :type => Drop::REDIRECT,
      :redirect_url => mock_url
    )

    assert_equal 0, drop.stats.visits
    get :show, :id => 'omg/lol'
    assert_redirected_to mock_url

    # since we track stats async need to give
    # the thread a chance to do it's work
    sleep(1.0/24.0) 
    assert_equal 1, drop.stats.visits
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
    assert_equal mock_file.content_type, response.headers['Content-Type']
  end

end
