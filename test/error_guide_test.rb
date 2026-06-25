# frozen_string_literal: true

require_relative "test_helper"

class ErrorGuideTest < Minitest::Test
  def test_rate_limit_is_defined
    assert Ask::Honeybadger::Errors::RATE_LIMIT[:authenticated]
    assert Ask::Honeybadger::Errors::RATE_LIMIT[:action]
  end

  def test_rate_limit_has_actionable_guide
    assert_includes Ask::Honeybadger::Errors::RATE_LIMIT[:action], "X-RateLimit-Reset"
  end

  def test_status_codes_include_common_errors
    [401, 403, 404, 429, 500, 503].each do |code|
      assert Ask::Honeybadger::Errors::STATUS_CODES[code], "Missing status code #{code}"
    end
  end

  def test_status_codes_have_descriptions
    Ask::Honeybadger::Errors::STATUS_CODES.each do |code, desc|
      refute_empty desc, "Status code #{code} description is empty"
    end
  end

  def test_pagination_is_defined
    assert Ask::Honeybadger::Errors::PAGINATION[:links]
    assert Ask::Honeybadger::Errors::PAGINATION[:next_page]
    assert Ask::Honeybadger::Errors::PAGINATION[:results_key]
  end

  def test_exceptions_include_faraday_errors
    expected = %w[Faraday::UnauthorizedError Faraday::ForbiddenError
                  Faraday::ResourceNotFound Faraday::TimeoutError
                  Faraday::ConnectionFailed Faraday::ServerError]
    expected.each { |e| assert Ask::Honeybadger::Errors::EXCEPTIONS[e], "Missing #{e}" }
  end

  def test_exceptions_have_action_and_message
    Ask::Honeybadger::Errors::EXCEPTIONS.each do |name, guide|
      assert guide[:message], "#{name} missing message"
      assert guide[:action], "#{name} missing action"
    end
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

  def test_rate_limit_headers_are_documented
    headers = Ask::Honeybadger::Errors::RATE_LIMIT[:headers]
    assert headers[:limit]
    assert headers[:remaining]
    assert headers[:reset]
  end
end
