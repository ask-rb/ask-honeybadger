# frozen_string_literal: true

module Ask
  module Honeybadger
    # Structured error knowledge for AI agents working with the Honeybadger API.
    #
    # Provides human-readable guidance for common HTTP status codes, rate
    # limiting, pagination, and authentication errors encountered when
    # using the Honeybadger Data API.
    module Errors
      # Rate limit information.
      #
      # - Authenticated requests: 360 requests per hour
      #
      # When rate-limited, the API returns HTTP 403 (Forbidden). The agent
      # should check the +X-RateLimit-Reset+ header and wait until that
      # timestamp before retrying.
      RATE_LIMIT = {
        authenticated: "360 requests per hour (using API token)",
        error_class: "Faraday::ForbiddenError",
        action: "Check the X-RateLimit-Reset header, wait until that Unix timestamp, then retry the request.",
        headers: {
          limit: "X-RateLimit-Limit — number of requests you can make per hour",
          remaining: "X-RateLimit-Remaining — number of requests remaining in the current window",
          reset: "X-RateLimit-Reset — Unix timestamp when the rate limit resets"
        }
      }.freeze

      # Common HTTP status codes returned by the Honeybadger API and how to handle them.
      STATUS_CODES = {
        200 => "OK — Request succeeded.",
        201 => "Created — Resource was created successfully.",
        204 => "No Content — Request succeeded, no response body.",
        301 => "Moved Permanently — The resource URL has changed; update your reference.",
        400 => "Bad Request — The request was malformed. Check parameters.",
        401 => "Unauthorized — Token is missing, invalid, or revoked. Re-authenticate.",
        403 => "Forbidden — Token lacks permissions or rate limit exceeded. Check token or retry later.",
        404 => "Not Found — Resource does not exist or is private.",
        409 => "Conflict — Resource state conflict.",
        422 => "Unprocessable Entity — Validation failed. Check request parameters.",
        429 => "Too Many Requests — Rate limit exceeded. Wait before retrying.",
        500 => "Internal Server Error — Honeybadger server issue. Retry with backoff.",
        502 => "Bad Gateway — Honeybadger upstream issue. Retry with backoff.",
        503 => "Service Unavailable — Honeybadger is down for maintenance. Retry later."
      }.freeze

      # Pagination guidance for the Honeybadger API.
      PAGINATION = {
        links: "List responses include a links hash with 'self', 'next', and 'prev' URLs.",
        next_page: "Load the next page by following the URL in the 'next' link.",
        prev_page: "Load the previous page by following the URL in the 'prev' link.",
        results_key: "Results are in the 'results' array within the response body.",
        missing_links: "If next or prev links are missing, there is no further page in that direction."
      }.freeze

      # Map of exception classes to human-readable guidance.
      EXCEPTIONS = {
        "Faraday::UnauthorizedError" => {
          message: "Your Honeybadger API token is invalid or has been revoked.",
          action: "Generate a new token at https://app.honeybadger.io/users/edit"
        },
        "Faraday::ForbiddenError" => {
          message: "Your token lacks the required permissions, or the rate limit has been exceeded.",
          action: "Check your token permissions. If rate-limited, wait until the X-RateLimit-Reset timestamp."
        },
        "Faraday::ResourceNotFound" => {
          message: "The requested project or fault does not exist or is not accessible.",
          action: "Verify the project ID or fault ID. Ensure the token has access to this resource."
        },
        "Faraday::ParsingError" => {
          message: "Failed to parse the API response.",
          action: "The API may have returned an unexpected format. Check the raw response body."
        },
        "Faraday::TimeoutError" => {
          message: "The request timed out.",
          action: "Retry with exponential backoff. If the issue persists, check https://status.honeybadger.io."
        },
        "Faraday::ConnectionFailed" => {
          message: "Failed to connect to the Honeybadger API.",
          action: "Check your network connection and verify that https://app.honeybadger.io is reachable."
        },
        "Faraday::ServerError" => {
          message: "Honeybadger encountered a server error (5xx).",
          action: "Retry with exponential backoff. If the issue persists, check https://status.honeybadger.io."
        }
      }.freeze

      # Look up guidance for an exception class name.
      #
      # @param exception_class [String] The exception class name (e.g., "Faraday::ResourceNotFound")
      # @return [Hash, nil] A hash with +:message+ and +:action+ keys, or nil if unknown
      def self.for(exception_class)
        EXCEPTIONS[exception_class]
      end

      # Describe an HTTP status code.
      #
      # @param code [Integer] HTTP status code
      # @return [String, nil] Description of the status code
      def self.status_code_description(code)
        STATUS_CODES[code]
      end
    end
  end
end
