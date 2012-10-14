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

  def mock_file
    FileWithContentType.open(Rails.root.join("test", "fixtures", "farnsworth.png"))
  end

end

class ActionController::TestCase
  def mock_file
    fixture_file_upload(Rails.root.join('test', 'fixtures', 'farnsworth.png'))
  end
end


class FileWithContentType < File
  def content_type
    "image/png"
  end
end

class Rack::Test::UploadedFile
  # By default this is nil, set this to a value so we can test
  def content_type
    "image/png"
  end
end
