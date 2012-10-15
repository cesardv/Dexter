require 'test_helper'

class DropsControllerTest < ActionController::TestCase
  setup do
    Rails.application.config.settings[:private_server] = false
  end

  test "new" do
    get :new
    assert_response :success
  end

  test "create redirect success" do
    post :create, :drop => {
      :id => 'omg',
      :redirect_url => mock_url,
      :type => Drop::REDIRECT
    }

    drop = Drop.find_by_id('omg')
    assert_not_nil drop
    assert_redirected_to drop_path(drop)
    assert_equal mock_url, drop.redirect_url
  end

  test "create file success" do
    post :create, :drop => {
      :id   => 'omg',
      :type => Drop::FILE,
      :file => mock_file
    }

    drop = Drop.find_by_id('omg')
    assert_not_nil drop
    assert_redirected_to drop_path(drop)
    #assert_equal mock_file.read.encoding, drop.file.read.encoding

    tmp_file_path = Rails.root.join("tmp", "test_file")
    File.open(tmp_file_path, "wb") {|f| f.write(drop.file.read) }

    assert FileUtils.compare_file(tmp_file_path, Rails.root.join("test", "fixtures", "farnsworth.png"))
    File.delete(tmp_file_path)
  end

  test "create failure" do
    post :create, :drop => Hash.new

    assert_response :unprocessable_entity
  end

  test "show not found" do
    get :show, :id => 'omg'
    assert_response :not_found
  end

  test "show found" do
    drop = Drop.create(:id => 'omg', :type => Drop::REDIRECT, :redirect_url => mock_url)
    assert drop.valid?
    get :show, :id => 'omg'
    assert_response :success
  end

end
