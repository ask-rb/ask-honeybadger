# frozen_string_literal: true

require_relative "test_helper"

class ErrorGuideTest < Minitest::Test
  def test_rate_limit_is_defined
    assert Ask::Honeybadger::Errors::RATE_LIMIT[:authenticated]
    assert_equal 360, Ask::Honeybadger::Errors::RATE_LIMIT[:authenticated].to_i
  end

  def test_rate_limit_has_actionable_guide
    assert Ask::Honeybadger::Errors::RATE_LIMIT[:action]
    assert_includes Ask::Honeybadger::Errors::RATE_LIMIT[:action], "X-RateLimit-Reset"
  end

  def test_status_codes_include_common_errors
    assert Ask::Honeybadger::Errors::STATUS_CODES[401]
    assert Ask::Honeybadger::Errors::STATUS_CODES[403]
    assert Ask::Honeybadger::Errors::STATUS_CODES[404]
    assert Ask::Honeybadger::Errors::STATUS_CODES[429]
    assert Ask::Honeybadger::Errors::STATUS_CODES[500]
    assert Ask::Honeybadger::Errors::STATUS_CODES[503]
  end

  def test_pagination_is_defined
    assert Ask::Honeybadger::Errors::PAGINATION[:links]
    assert Ask::Honeybadger::Errors::PAGINATION[:next_page]
    assert Ask::Honeybadger::Errors::PAGINATION[:results_key]
  end

  def test_exceptions_include_faraday_errors
    assert Ask::Honeybadger::Errors::EXCEPTIONS["Faraday::UnauthorizedError"]
    assert Ask::Honeybadger::Errors::EXCEPTIONS["Faraday::ForbiddenError"]
    assert Ask::Honeybadger::Errors::EXCEPTIONS["Faraday::ResourceNotFound"]
    assert Ask::Honeybadger::Errors::EXCEPTIONS["Faraday::TimeoutError"]
    assert Ask::Honeybadger::Errors::EXCEPTIONS["Faraday::ConnectionFailed"]
    assert Ask::Honeybadger::Errors::EXCEPTIONS["Faraday::ServerError"]
  end

  def test_for_returns_guidance_for_known_exception
    guidance = Ask::Honeybadger::Errors.for("Faraday::ResourceNotFound")
    assert guidance
    assert guidance[:message]
    assert guidance[:action]
  end

  def test_for_returns_nil_for_unknown_exception
    assert_nil Ask::Honeybadger::Errors.for("Unknown::Error")
  end

  def test_status_code_description_returns_string
    desc = Ask::Honeybadger::Errors.status_code_description(401)
    assert desc
    assert_includes desc, "Unauthorized"
  end

  def test_status_code_description_returns_nil_for_unknown
    assert_nil Ask::Honeybadger::Errors.status_code_description(999)
  end
end
