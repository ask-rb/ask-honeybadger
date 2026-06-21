# frozen_string_literal: true

require_relative "test_helper"

class ContextTest < Minitest::Test
  def test_description_is_defined
    assert_match(/Honeybadger/, Ask::Honeybadger::DESCRIPTION)
  end

  def test_docs_url_is_defined
    assert Ask::Honeybadger::DOCS_URL.start_with?("https://docs.honeybadger.io")
  end

  def test_auth_name_is_honeybadger_token
    assert_equal :honeybadger_token, Ask::Honeybadger::AUTH_NAME
  end

  def test_auth_how_is_defined
    assert_includes Ask::Honeybadger::AUTH_HOW, "honeybadger.io"
  end

  def test_gem_name_is_honeybadger_ruby
    assert_equal "honeybadger-ruby", Ask::Honeybadger::GEM_NAME
  end

  def test_quick_start_is_defined
    assert_includes Ask::Honeybadger::QUICK_START, "Ask::Honeybadger.client"
  end

  def test_quick_start_includes_examples
    assert_includes Ask::Honeybadger::QUICK_START, "recent_faults"
  end
end
