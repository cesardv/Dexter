ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  setup do
    REDIS.flushall
  end

  def mock_url
    @mock_url ||= "http://google.com"
  end

end
