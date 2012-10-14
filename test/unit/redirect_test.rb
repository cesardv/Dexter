require 'test_helper'

class RedirectTest < ActiveSupport::TestCase
  should allow_value("http://omg.com").for(:redirect_url)
  should_not allow_value(nil).for(:redirect_url)
  should_not allow_value("lol").for(:redirect_url)
  should_not allow_value("http://").for(:redirect_url)
end
