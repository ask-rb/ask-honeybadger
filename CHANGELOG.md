## [Unreleased] - 2026-09-22

### Deprecated

- This gem is deprecated. Use Honeybadger's official MCP server instead:
  https://docs.honeybadger.io/resources/mcp/

## [0.1.5] - 2026-09-18

### Changed

- Requires `ask-core >= 0.12.0` for the decision vocabulary
  (`Ask::Decision`, `Ask::DecisionProvider`, `Ask::DecisionResult`).
  Nothing else changed.

## [0.1.2] - 2026-06-25

### Changed
- Expanded tests: Client(10t), ErrorGuide(12t), Context(8t). Infrastructure: rubocop, overcommit, bin/setup, CI matrix, gemspec, SimpleCov.
# Changelog

## v0.1.0 (2026-06-10)

- Initial release
- context.rb: DESCRIPTION, QUICK_START, AUTH_NAME, and auth instructions
- client.rb: Faraday-based HTTP client with Basic Auth and retry middleware
- error_guide.rb: Structured error knowledge for common API errors
- Convenience methods: recent_faults, fault_summary, fault, projects
