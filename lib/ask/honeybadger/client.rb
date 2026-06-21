# frozen_string_literal: true

require "faraday"
require "faraday/retry"
require "ask/auth"

module Ask
  module Honeybadger
    # Base URL for the Honeybadger Data API.
    BASE_URL = "https://app.honeybadger.io/v2"

    # Returns an authenticated Faraday client for the Honeybadger Data API.
    #
    # Resolves the Honeybadger API token via +Ask::Auth.resolve(:honeybadger_token)+
    # and configures the client with sensible defaults:
    #
    # - +request+: JSON encoding
    # - +response+: JSON decoding
    # - +retry+: Faraday retry middleware (3 retries, exponential backoff)
    # - +auth+: HTTP Basic Auth with token as username and blank password
    #
    # The client is wrapped in a +ClientProxy+ that converts
    # +Faraday::UnauthorizedError+ into +Ask::Auth::InvalidCredential+.
    #
    # @example
    #   client = Ask::Honeybadger.client
    #   client.get("/v2/projects/ID/faults")
    #
    # @return [Faraday::Connection] an authenticated HTTP client
    # @raise [Ask::Auth::MissingCredential] if no Honeybadger token is configured
    # @raise [Ask::Auth::InvalidCredential] if the token is rejected (401)
    def self.client
      token = Ask::Auth.resolve(:honeybadger_token)

      conn = Faraday.new(url: BASE_URL) do |f|
        # HTTP Basic Auth: token is the username, password is blank
        f.request :authorization, :basic, token, ""

        # JSON request/response handling
        f.request :json
        f.response :json

        # Retry middleware for transient failures
        f.request :retry, max: 3, interval: 1, backoff_factor: 2,
                          retry_statuses: [429, 500, 502, 503]

        f.adapter Faraday.default_adapter
      end

      ClientProxy.new(conn)
    end

    # Convenience: fetch recent faults for a project.
    #
    # @param project_id [String, Integer] The Honeybadger project ID
    # @param limit [Integer] Number of faults to return (max 25)
    # @param params [Hash] Additional query parameters (q, order, environment, etc.)
    # @return [Hash] Response with +results+ array and +links+
    def self.recent_faults(project_id:, limit: 25, **params)
      params[:limit] = limit
      client.get("/v2/projects/#{project_id}/faults", params).body
    end

    # Convenience: get a fault summary (counts grouped by environment, status, etc.).
    #
    # @param project_id [String, Integer] The Honeybadger project ID
    # @param params [Hash] Additional query parameters
    # @return [Hash] Fault summary with counts
    def self.fault_summary(project_id:, **params)
      client.get("/v2/projects/#{project_id}/faults/summary", params).body
    end

    # Convenience: fetch a single fault by ID.
    #
    # @param project_id [String, Integer] The Honeybadger project ID
    # @param fault_id [String, Integer] The fault ID
    # @return [Hash] Fault details
    def self.fault(project_id:, fault_id:)
      client.get("/v2/projects/#{project_id}/faults/#{fault_id}").body
    end

    # Convenience: list all projects accessible with this token.
    #
    # @return [Hash] Response with +results+ array and +links+
    def self.projects
      client.get("/v2/projects").body
    end

    # Proxies method calls to a +Faraday::Connection+, converting
    # authentication errors into +Ask::Auth::InvalidCredential+.
    class ClientProxy < BasicObject
      def initialize(client)
        @client = client
      end

      def method_missing(name, ...)
        @client.public_send(name, ...)
      rescue ::Faraday::UnauthorizedError
        ::Kernel.raise ::Ask::Auth::InvalidCredential, :honeybadger_token
      end

      def respond_to_missing?(name, include_private = false)
        @client.respond_to?(name, include_private) || super
      end
    end
  end
end
