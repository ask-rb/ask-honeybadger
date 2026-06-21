---
name: honeybadger.use_honeybadger
description: How to navigate the Honeybadger Data API — fetch faults, projects, and error details
---

Use this skill when you need to interact with Honeybadger — reviewing error
faults, checking project health, or debugging production issues.

## Step 1: Get the Client

```ruby
client = Ask::Honeybadger.client
```

This returns an authenticated `Faraday::Connection` pointed at
`https://app.honeybadger.io/v2`. It expects a valid Honeybadger API token
resolved via `Ask::Auth.resolve(:honeybadger_token)`.

## Step 2: Explore the Context

```ruby
Ask::Honeybadger::Context::DOCS_URL    # Honeybadger API docs
Ask::Honeybadger::Context::QUICK_START # Copy-paste examples
```

The `QUICK_START` has examples for listing projects, faults, and fault details.

## Step 3: Use Convenience Helpers First

The gem ships with helpers for the most common operations:

```ruby
# List projects
projects = Ask::Honeybadger.projects

# Recent faults for a project
faults = Ask::Honeybadger.recent_faults(project_id: "PROJECT_ID", limit: 10)

# Fault summary (counts by environment, status)
summary = Ask::Honeybadger.fault_summary(project_id: "PROJECT_ID")

# Single fault details
fault = Ask::Honeybadger.fault(project_id: "PROJECT_ID", fault_id: "FAULT_ID")
```

The client returns parsed JSON hashes. Use `Code` to inspect the response
structure.

## Step 4: Raw API Calls for Custom Needs

For endpoints without convenience helpers, use the Faraday client directly:

```ruby
client = Ask::Honeybadger.client

# GET request
response = client.get("/v2/projects/PROJECT_ID/faults/FAULT_ID/notices")
response.body

# With query parameters
response = client.get("/v2/projects/PROJECT_ID/faults", { q: "search term", order: "count" })
response.body
```

The API is REST-based. All responses are automatically JSON-parsed (Faraday
middleware handles this).

## Step 5: Authentication & Common Errors

```ruby
Ask::Honeybadger::Errors.status_code_description(401)
Ask::Honeybadger::Errors.status_code_description(429)
```

Common scenarios:
- **401**: Token invalid or revoked → generate new token at Honeybadger settings
- **404**: Wrong project ID → list projects first to get correct IDs
- **429**: Rate limited → wait and retry (Faraday auto-retries 3 times)
- **500/502/503**: Honeybadger server issue → Faraday auto-retries

## Step 6: Fallback Strategy

1. Reference `Ask::Honeybadger::Context::DOCS_URL` for the full API reference
2. The Honeybadger API is REST + JSON — you can use any standard HTTP method
3. List projects first to get correct IDs before querying faults
