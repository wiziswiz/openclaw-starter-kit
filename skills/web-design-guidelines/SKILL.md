---
name: web-design-guidelines
description: >
  Review UI code for Web Interface Guidelines compliance, checking accessibility, 
  design patterns, and UX best practices against Vercel's curated standards.
  
  Use when:
  - User says "review my UI", "check accessibility", "audit design", "review UX"
  - Asked to "check my site against best practices" or "web guidelines"
  - Code review focused on UI/UX compliance
  - Need to validate interface patterns and accessibility
  - User mentions "web interface guidelines" or specific compliance checks
  - Working with React, Next.js, or web frontend components

  Don't use when:
  - User wants backend code review or non-UI code analysis
  - Need performance optimization (use performance-specific skills instead)
  - Looking for SEO audit (different from UI guidelines)
  - User asks about mobile app design (this is web-specific)
  - Need brand guidelines or visual design feedback beyond technical compliance
  
  Inputs: File paths or patterns containing UI/frontend code
  Outputs: Terse file:line violations with rule explanations and fixes
  Success: Clear list of guideline violations with actionable recommendations

metadata:
  author: vercel
  version: "1.0.0"
  argument-hint: <file-or-pattern>
---

# Web Interface Guidelines

Review files for compliance with Web Interface Guidelines.

## How It Works

1. Fetch the latest guidelines from the source URL below
2. Read the specified files (or prompt user for files/pattern)
3. Check against all rules in the fetched guidelines
4. Output findings in the terse `file:line` format

## Guidelines Source

Fetch fresh guidelines before each review:

```
https://raw.githubusercontent.com/vercel-labs/web-interface-guidelines/main/command.md
```

Use WebFetch to retrieve the latest rules. The fetched content contains all the rules and output format instructions.

## Usage

When a user provides a file or pattern argument:
1. Fetch guidelines from the source URL above
2. Read the specified files
3. Apply all rules from the fetched guidelines
4. Output findings using the format specified in the guidelines

If no files specified, ask the user which files to review.
