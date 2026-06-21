# frozen_string_literal: true

module Ask
  module Honeybadger
    # Human-readable description of the Honeybadger service context.
    DESCRIPTION = "Honeybadger — error tracking via the Honeybadger API"

    # Base URL for Honeybadger API documentation.
    DOCS_URL = "https://docs.honeybadger.io/api/"

    # Credential name used with Ask::Auth.resolve.
    AUTH_NAME = :honeybadger_token

    # Instructions for obtaining a Honeybadger API token.
    AUTH_HOW = "https://app.honeybadger.io/users/edit"

    # Gem name for the Honeybadger Ruby integration.
    GEM_NAME = "honeybadger-ruby"

    # Quick-start Ruby code snippet for agents to copy-paste.
    QUICK_START = <<~RUBY
      client = Ask::Honeybadger.client

      # List faults for a project:
      faults = client.get("/v2/projects/PROJECT_ID/faults")

      # Get fault details:
      fault = client.get("/v2/projects/PROJECT_ID/faults/FAULT_ID")

      # List projects:
      projects = client.get("/v2/projects")

      # Convenience helpers:
      Ask::Honeybadger.recent_faults(project_id: "PROJECT_ID", limit: 10)
      Ask::Honeybadger.fault_summary(project_id: "PROJECT_ID")
    RUBY
  end
end
