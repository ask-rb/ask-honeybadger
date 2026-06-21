# frozen_string_literal: true

require_relative "test_helper"

class ClientTest < Minitest::Test
  def setup
    super
    @token = "hb_test_token_12345"
    Ask::Auth.configure do |config|
      config.providers = [->(name, user: nil) { @token if name == "honeybadger_token" }]
    end
  end

  def test_client_returns_faraday_connection_when_token_available
    client = Ask::Honeybadger.client
    assert_kind_of Faraday::Connection, client
  end

  def test_client_has_correct_base_url
    client = Ask::Honeybadger.client
    assert_equal Ask::Honeybadger::BASE_URL, client.url_prefix.to_s.chomp("/")
  end

  def test_client_raises_missing_credential_without_token
    Ask::Auth.configure do |config|
      config.providers = []
    end

    assert_raises(Ask::Auth::MissingCredential) { Ask::Honeybadger.client }
  end

  def test_client_raises_invalid_credential_on_401
    conn = stub("faraday_connection")
    Faraday.stubs(:new).returns(conn)
    conn.stubs(:get).raises(Faraday::UnauthorizedError, nil)

    assert_raises(Ask::Auth::InvalidCredential) { Ask::Honeybadger.client.get("/v2/projects") }
  end
end
