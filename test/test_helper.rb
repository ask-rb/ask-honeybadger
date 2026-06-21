# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "ask-honeybadger"
require "minitest/autorun"
require "mocha/minitest"

# Reset auth configuration before each test
class Minitest::Test
  def setup
    Ask::Auth.reset_configuration!
  end
end
