# ask-honeybadger

[![Gem Version](https://badge.fury.io/rb/ask-honeybadger.svg)](https://badge.fury.io/rb/ask-honeybadger)

> **⚠️ DEPRECATED:** This gem is deprecated. Use Honeybadger's official MCP
> server instead: https://docs.honeybadger.io/resources/mcp/ (hosted endpoint:
> https://mcp.honeybadger.io/mcp — use the EU endpoint for EU accounts).
> Existing gem installations may continue to work, but this repository will
> receive no further feature development. See the official MCP documentation
> for setup and capabilities.

Honeybadger service context for AI agents in the ask-rb ecosystem. It provides
an authenticated HTTP client for the Honeybadger Data API, metadata constants
for system prompts, and a structured error guide for common Honeybadger API
issues.

## Installation

```ruby
gem "ask-honeybadger"
```

## Quick Start

```ruby
require "ask-honeybadger"

# List all projects
Ask::Honeybadger.projects

# Recent faults for a project
faults = Ask::Honeybadger.recent_faults(project_id: "PROJECT_ID", limit: 10)

# Summary counts for a project
Ask::Honeybadger.fault_summary(project_id: "PROJECT_ID")

# A single fault
Ask::Honeybadger.fault(project_id: "PROJECT_ID", fault_id: 42)

# Or use the raw client (base URL: https://app.honeybadger.io/v2)
client = Ask::Honeybadger.client
client.get("/v2/projects/PROJECT_ID/faults")
```

## Authentication

`Ask::Honeybadger.client` resolves a token via
`Ask::Auth.resolve(:honeybadger_token)`. Set it in your environment:

```bash
export HONEYBADGER_TOKEN=your_token_here
```

Or add it to `~/.ask/credentials.yml`:

```yaml
honeybadger_token: your_token_here
```

Credentials can also come from Rails credentials, a database, or an OAuth
provider, depending on your `ask-auth` configuration. The token is sent as
HTTP Basic auth with the token as the username and a blank password. Get your
token at [app.honeybadger.io/users/edit](https://app.honeybadger.io/users/edit).

## Key entry points

- `Ask::Honeybadger.client` - an authenticated Faraday client with base URL
  `https://app.honeybadger.io/v2`. It is wrapped in a proxy that converts
  auth failures into `Ask::Auth::InvalidCredential`.
- `Ask::Honeybadger.recent_faults(project_id:, limit: 25, **params)` - fetch
  recent faults with optional query params (`q`, `order`, `environment`).
- `Ask::Honeybadger.fault_summary(project_id:)`, `fault(project_id:, fault_id:)`,
  and `projects` - other convenience helpers.
- `Ask::Honeybadger::Errors` - structured error knowledge for agents:
  guidance by exception class, HTTP status descriptions, and rate limit info.
- `Ask::Honeybadger::DESCRIPTION`, `DOCS_URL`, `AUTH_NAME`, `GEM_NAME`, and
  `QUICK_START` - metadata constants for system prompts.

## Full documentation

The full ask-rb documentation lives at https://ask-rb.github.io/ask-docs.
[Services: Honeybadger](https://ask-rb.github.io/ask-docs/services/honeybadger)
covers ask-honeybadger in depth, including the client, error guide, and
constants. API reference: https://ask-rb.github.io/ask-docs/reference/api.

## Development

```
bundle install
bundle exec rake test
```

## License

MIT
