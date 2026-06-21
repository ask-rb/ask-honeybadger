# ask-honeybadger

Honeybadger — error tracking via the Honeybadger API

Part of the [ask-rb](https://github.com/ask-rb) ecosystem.

## Installation

```ruby
gem "ask-honeybadger"
```

## Usage

```ruby
require "ask-honeybadger"

# Get an authenticated client:
client = Ask::Honeybadger.client

# List faults for a project:
faults = client.get("/v2/projects/PROJECT_ID/faults")

# Or use the convenience helpers:
Ask::Honeybadger.recent_faults(project_id: "PROJECT_ID", limit: 10)
Ask::Honeybadger.fault_summary(project_id: "PROJECT_ID")
Ask::Honeybadger.fault(project_id: "PROJECT_ID", fault_id: 42)
Ask::Honeybadger.projects
```

## Authentication

Set your Honeybadger API token in the environment:

```bash
export HONEYBADGER_TOKEN=your_token_here
```

Or add it to `~/.ask/credentials.yml`:

```yaml
honeybadger_token: your_token_here
```

Get your token at https://app.honeybadger.io/users/edit

## Development

```bash
bundle exec rake test
```

## License

MIT
