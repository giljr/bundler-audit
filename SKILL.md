---
name: bundler-audit
description: >
  Complete guide to installing, configuring, and running bundler-audit in Ruby/Rails projects.
  Use this skill whenever the user mentions bundler-audit, gem auditing, vulnerabilities
  in Ruby gems, dependency CVEs, secure gem updates, or wants to ensure security
  in a Rails project's dependencies. Also trigger for bundler-audit result analysis,
  CVE/GHSA interpretation, and safe production update strategies.
---

# bundler-audit — Security Auditing for Ruby Gems

## What is bundler-audit?

`bundler-audit` is a tool that checks a project's `Gemfile.lock` against a database of known vulnerabilities (CVEs and GHSAs), identifying gems with security issues and recommending safe versions.

---

## Step-by-Step Installation

### 1. Add it to the Gemfile

Add it only to the development group — it is not required in production:

```ruby
group :development do
  gem 'bundler-audit', require: false
end
```

### 2. Install project gems

```bash
bundle install
```

### 3. Update the vulnerability database

bundler-audit maintains a local copy of the advisory database. Always update it before auditing:

```bash
bundle exec bundler-audit update
```

> The database contains hundreds of advisories (e.g., 1007 advisories, updated on 2025-08-15).

### 4. Run the audit

```bash
bundle exec bundler-audit check --update
```

The `--update` flag ensures the database is automatically updated before the scan.

---

## Interpreting Results

bundler-audit reports each vulnerable gem with:

| Field | Description |
|---|---|
| **Gem** | Name of the affected gem |
| **Version** | Currently installed version |
| **Advisory** | CVE or GHSA identifier |
| **Criticality** | Severity level: Unknown / Low / Medium / High / Critical |
| **Title** | Short vulnerability description |
| **Solution** | Recommended safe version |

**Clean result:**
```
No vulnerabilities found
```

**Vulnerability found (example):**
```
Name: rack
Version: 3.1.8
Advisory: CVE-2025-27610
Criticality: High
Title: Path traversal vulnerability
Solution: upgrade to >= 3.1.16
```

---

## Safe Update Strategy

### Development / Staging Environment

You can update all vulnerable gems at once:

```bash
bundle update nokogiri rack net-imap activerecord activestorage rack-session thor uri
```

### Production Environment (Recommended: Gradual Updates)

> ⚠️ **Warning:** In production, update one gem at a time and run tests after each update.

```bash
# 1. Update a single gem
bundle update rack

# 2. Run application tests
rails test -v

# 3. Verify bundler-audit is satisfied with the updated gem
bundle exec bundler-audit check

# 4. Repeat for the next gem
```

### Update All System Gems (Optional)

```bash
gem update
```

> Use with caution — this may introduce compatibility issues in projects that do not explicitly manage gem versions.

---

## Common Vulnerabilities (Reference)

| Gem | Common CVEs | Risk Type |
|---|---|---|
| `nokogiri` | GHSA-mrxw-mxhj-p664 | libxml2/libxslt issues |
| `rack` | CVE-2025-25184, 27610 | Log injection, LFI, DoS, ReDoS |
| `net-imap` | CVE-2025-25186 | Memory exhaustion DoS |
| `activerecord` | CVE-2025-55193 | ANSI escape injection in logs |
| `activestorage` | CVE-2025-24293 | Potentially unsafe transformations |
| `rack-session` | CVE-2025-46336 | Session restoration after deletion |
| `thor` | CVE-2025-54314 | Shell input injection |
| `uri` | CVE-2025-27221 | Userinfo leakage in URI join/merge |

---

## CI/CD Integration

Add the audit to your pipeline to block deployments when vulnerabilities are detected:

```yaml
# GitHub Actions example
- name: Audit gems
  run: bundle exec bundler-audit check --update
```

The command returns exit code `1` if vulnerabilities are found, automatically stopping the pipeline.

---

## Recommended Complete Workflow

```text
1. bundle exec bundler-audit update      # Update advisory database
2. bundle exec bundler-audit check       # Check for vulnerabilities
3. bundle update <vulnerable-gem>        # Update one gem at a time (production)
4. rails test -v                         # Verify nothing broke
5. bundle exec bundler-audit check       # Confirm the vulnerability is fixed
6. Repeat until: "No vulnerabilities found"
```

---

## What Are CVEs and GHSAs?

- **CVE** (Common Vulnerabilities and Exposures): a global vulnerability identifier maintained by MITRE. Example: `CVE-2025-27610`.
- **GHSA** (GitHub Security Advisory): a vulnerability identifier reported through GitHub. Example: `GHSA-mrxw-mxhj-p664`.
- Both are tracked by the bundler-audit advisory database.
