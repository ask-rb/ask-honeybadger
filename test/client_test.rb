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

  def test_client_returns_faraday_connection
    client = Ask::Honeybadger.client
    assert_kind_of Faraday::Connection, client
  end

  def test_client_has_correct_base_url
    client = Ask::Honeybadger.client
    assert_includes client.url_prefix.to_s, Ask::Honeybadger::BASE_URL
  end

  def test_client_raises_missing_credential_without_token
    Ask::Auth.configure { |c| c.providers = [] }
    assert_raises(Ask::Auth::MissingCredential) { Ask::Honeybadger.client }
  end

  def test_client_proxy_wraps_connection
    conn = stub("faraday")
    Faraday.stubs(:new).returns(conn)
    conn.stubs(:get).returns(stub(status: 200, body: { "results" => [] }))
    conn.stubs(:url_prefix).returns(URI.parse("https://app.honeybadger.io/v2"))
    client = Ask::Honeybadger.client
    assert_respond_to client, :get
    assert_respond_to client, :get
  end

  def test_client_proxy_converts_unauthorized
    conn = stub("faraday")
    Faraday.stubs(:new).returns(conn)
    conn.stubs(:get).raises(Faraday::UnauthorizedError, nil)
    assert_raises(Ask::Auth::InvalidCredential) { Ask::Honeybadger.client.get("/v2/projects") }
  end

  def test_base_url_constant
    assert Ask::Honeybadger::BASE_URL.start_with?("https://")
  end

  def test_recent_faults_raises_without_token
    Ask::Auth.configure { |c| c.providers = [] }
    assert_raises(Ask::Auth::MissingCredential) { Ask::Honeybadger.recent_faults(project_id: "123") }
  end

  def test_fault_summary_raises_without_token
    Ask::Auth.configure { |c| c.providers = [] }
    assert_raises(Ask::Auth::MissingCredential) { Ask::Honeybadger.fault_summary(project_id: "123") }
  end

  def test_fault_raises_without_token
    Ask::Auth.configure { |c| c.providers = [] }
    assert_raises(Ask::Auth::MissingCredential) { Ask::Honeybadger.fault(project_id: "123", fault_id: "456") }
  end

  def test_projects_raises_without_token
    Ask::Auth.configure { |c| c.providers = [] }
    assert_raises(Ask::Auth::MissingCredential) { Ask::Honeybadger.projects }
  end
end
