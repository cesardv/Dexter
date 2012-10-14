require 'test_helper'

class FileDropTest < ActiveSupport::TestCase
  should_not allow_value(nil).for(:file)

end
