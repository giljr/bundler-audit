# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Purpose

This is a Rails 8 demo app that serves as the test target for a bundler-audit Claude Code skill. It demonstrates secure authentication without Devise, and is designed to be compatible with bundler-audit, Brakeman, RuboCop, and RubyCritic in a CI/CD pipeline.

## Commands

```bash
# Setup
bundle install
rails db:create db:migrate

# Run the app
bin/dev                  # starts Puma dev server at localhost:3000

# Tests
rails test               # all tests
rails test test/path/to/test.rb  # single file
rails test test/path/to/test.rb:42  # single test by line number

# Security & quality
bundle exec bundler-audit check --update   # gem vulnerability audit
bundle exec brakeman -q                    # static security analysis
bundle exec rubocop                        # linting (rubocop-rails-omakase rules)
bundle exec rubycritic --no-browser        # code quality (min score: 75)
```

## Architecture

**Stack**: Rails 8.0.1 · SQLite · Hotwire (Turbo + Stimulus) · Import Maps · No Node/build pipeline

**Authentication** is hand-rolled with `has_secure_password` (no Devise):
- `User` model stores `password_digest` via bcrypt
- `ApplicationController#set_current_user` runs on every request, setting `Current.user` from `session[:user_id]`
- `Current < ActiveSupport::CurrentAttributes` provides thread-safe, per-request user context accessible everywhere
- `require_user_logged_in` is the before-action guard for protected routes
- Password reset uses `PasswordMailer` with a signed token

**Session flow**: `POST /sign_in` → authenticates via `user.authenticate(password)` → stores `session[:user_id]` → `DELETE /sign_out` clears it.

**Views**: Shared partials in `app/views/shared/` — `_navbar`, `_flash`, `_form_errors`, `_session_manager`.

**Tests**: Minitest with `minitest-reporters` (SpecReporter output). `SignInHelper#log_in_as` is available in all `ActionDispatch::IntegrationTest` subclasses. Fixtures are used for test data; `use_transactional_tests = true` wraps each test in a rollback.

**CI/CD**: GitLab CI (`.gitlab-ci.yml`) with four stages — `audit` (bundler-audit + brakeman), `quality` (rubycritic + rubocop), `test` (minitest), `release` (semantic-release via `.releaserc`).

**Timezone**: `America/Porto_Velho` — stored as local time in the DB.

## Security Tools

The skill definition for bundler-audit is at `docs/skill.md`. The `brakeman_report.txt` in the repo root is a committed sample report for reference.
