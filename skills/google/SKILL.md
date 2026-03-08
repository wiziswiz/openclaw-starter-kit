---
name: google
description: >
  Google Services integration providing access to Gmail, Google Calendar, and Google Drive 
  through authenticated RPC methods and natural language commands.
  
  Use when:
  - User asks about email, calendar, or drive operations
  - Need to check "my emails", "my calendar", "my drive files"
  - User wants to send emails, create calendar events, or search files
  - Mentions Gmail search, calendar management, or file organization
  - Need to integrate with Google Workspace for productivity tasks
  - User asks to "check my inbox", "what's on my calendar", "find file X"

  Don't use when:
  - User wants non-Google email services (use appropriate email client)
  - Looking for public web search (use web_search instead)
  - Need calendar services not connected to Google Calendar
  - User requests file operations on non-Google Drive storage
  - Authentication isn't set up or tokens are invalid
  - Need Google services beyond Gmail/Calendar/Drive scope
  
  Inputs: Natural language requests or RPC method calls with parameters
  Outputs: Email summaries, calendar events, file listings, operation confirmations
  Success: Successful Google API operations with relevant data retrieval or actions

metadata: {"openclaw":{"emoji":"G"}}
---

# Google Services

Access Gmail, Google Calendar, and Google Drive through OpenClaw.

## Setup

### 1. Google Cloud Console Setup

1. Go to https://console.cloud.google.com/
2. Create a new project or select an existing one
3. Enable these APIs:
   - Gmail API
   - Google Calendar API
   - Google Drive API
4. Go to "APIs & Services" > "Credentials"
5. Create OAuth 2.0 credentials (type: Desktop App)
6. Note the Client ID and Client Secret

### 2. Configure Environment Variables

Add to your shell profile (~/.bashrc, ~/.zshrc, etc.):

```bash
export GOOGLE_CLIENT_ID="your-client-id.apps.googleusercontent.com"
export GOOGLE_CLIENT_SECRET="your-client-secret"
```

### 3. Authenticate

Run this command and follow the browser prompts:

```bash
openclaw gateway call google.auth.login
```

Tokens are stored at `~/.openclaw/credentials/google/tokens.json`

## RPC Methods

All methods are accessed via `openclaw gateway call <method> [params]`

### Authentication

| Method | Description |
|--------|-------------|
| `google.auth.status` | Check authentication status |
| `google.auth.login` | Start OAuth flow to authenticate |

### Gmail

| Method | Parameters | Description |
|--------|------------|-------------|
| `gmail.summary` | `{maxResults?: number}` | Get inbox summary with unread count |
| `gmail.search` | `{query: string, maxResults?: number}` | Search emails (Gmail search syntax) |
| `gmail.read` | `{id: string}` | Read full email content |
| `gmail.markRead` | `{id: string}` | Mark email as read |
| `gmail.markUnread` | `{id: string}` | Mark email as unread |
| `gmail.archive` | `{id: string}` | Archive email (remove from inbox) |
| `gmail.trash` | `{id: string}` | Move email to trash |
| `gmail.send` | `{to, subject, body, cc?, bcc?}` | Send new email |
| `gmail.reply` | `{messageId, body}` | Reply to email |

**Gmail Search Examples:**
- `from:amazon` - Emails from Amazon
- `subject:invoice` - Emails with "invoice" in subject
- `is:unread` - Unread emails
- `newer_than:7d` - Last 7 days
- `has:attachment` - Emails with attachments

### Calendar

| Method | Parameters | Description |
|--------|------------|-------------|
| `calendar.today` | `{calendarId?: string}` | Get today's events |
| `calendar.upcoming` | `{days?: number, calendarId?: string}` | Get upcoming events (default: 7 days) |
| `calendar.search` | `{query, days?, calendarId?}` | Search events |
| `calendar.get` | `{eventId, calendarId?}` | Get event details |
| `calendar.create` | `{summary, start, end, ...}` | Create event |
| `calendar.delete` | `{eventId, calendarId?}` | Delete event |
| `calendar.list` | none | List all calendars |
| `calendar.freebusy` | `{emails[], start, end}` | Check availability |

**Date Format:** ISO 8601 - `2024-01-15T10:00:00-08:00`

### Drive

| Method | Parameters | Description |
|--------|------------|-------------|
| `drive.list` | `{folderId?, maxResults?}` | List files in folder (default: root) |
| `drive.listPath` | `{path, maxResults?}` | List files by folder path |
| `drive.search` | `{query, maxResults?}` | Search Drive files |
| `drive.get` | `{fileId}` | Get file metadata |
| `drive.read` | `{fileId}` | Read text file content |
| `drive.recent` | `{maxResults?}` | Recent files |
| `drive.starred` | `{maxResults?}` | Starred files |
| `drive.shared` | `{maxResults?}` | Files shared with me |
| `drive.createFolder` | `{name, parentId?}` | Create folder |
| `drive.move` | `{fileId, newParentId}` | Move file to folder |
| `drive.rename` | `{fileId, newName}` | Rename file |
| `drive.trash` | `{fileId}` | Move file to trash |
| `drive.star` | `{fileId, starred?}` | Star/unstar file |
| `drive.about` | none | Get Drive storage info |

## Example Usage

### From Terminal (Claude Code)

```bash
# Check if authenticated
openclaw gateway call google.auth.status

# Get inbox summary
openclaw gateway call gmail.summary

# Search for emails
openclaw gateway call gmail.search '{"query": "from:github is:unread"}'

# Get today's calendar
openclaw gateway call calendar.today

# Get next 14 days
openclaw gateway call calendar.upcoming '{"days": 14}'

# Create a meeting
openclaw gateway call calendar.create '{"summary": "Team Standup", "start": "2024-01-15T10:00:00-08:00", "end": "2024-01-15T10:30:00-08:00"}'

# List Drive root folder
openclaw gateway call drive.list

# Search Drive
openclaw gateway call drive.search '{"query": "project proposal"}'

# Read a Google Doc
openclaw gateway call drive.read '{"fileId": "1abc..."}'
```

### Natural Language (Telegram/iMessage)

When chatting with your agent:

- "What's on my calendar today?"
- "Do I have any unread emails?"
- "Search my email for invoices from last week"
- "What files do I have in my Projects folder on Drive?"
- "Create a meeting for tomorrow at 2pm called Team Sync"
- "Send an email to john@example.com about the project update"

## Notes

- Gmail operations use Gmail API search syntax
- Calendar times should be in ISO 8601 format with timezone
- Drive can read text files and Google Docs/Sheets/Slides
- Tokens auto-refresh when expired
- If you get auth errors, run `openclaw gateway call google.auth.login` again
