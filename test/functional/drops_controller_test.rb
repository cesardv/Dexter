require 'test_helper'

class DropsControllerTest < ActionController::TestCase
  test "new" do
    get :new
    assert_response :success
  end

  test "create success" do
    post :create, :drop => {
      :id => 'omg',
      :redirect_url => test_url,
      :type => Drop::REDIRECT
    }

    drop = Drop.find_by_id('omg')
    assert_not_nil drop
    assert_redirected_to drop_path(drop)
    assert_equal test_url, drop.redirect_url
  end

  test "create failure" do
    post :create, :drop => Hash.new

    assert_response :unprocessable_entity
  end

  private

  def test_url
    @test_url ||= "http://google.com"
  end
end
