require 'test_helper'

class DispatchesControllerTest < ActionController::TestCase

  test "redirection dispatches as expected" do
    drop = Drop.create(
      :id => 'omg/lol',
      :type => Drop::REDIRECT,
      :redirect_url => test_url
    )

    get :show, :id => 'omg/lol'
    assert_redirected_to test_url
  end

  test "dispatch not found" do
    get :show, :id => 'omg'
    assert_response :not_found
  end



  private

  def test_url
    @test_url ||= "http://google.com"
  end
end
