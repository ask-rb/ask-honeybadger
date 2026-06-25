if ENV["COVERAGE"]
  require "simplecov"
  SimpleCov.start do
    add_filter "/test/"
    add_filter "/vendor/"
    track_files "lib/**/*.rb"
  end
end

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
