-- Sample data for development environment
-- This file provides basic demo data for testing Memos

-- Create demo users
INSERT INTO user (id, username, role, email, nickname, password_hash, avatar_url, description) VALUES
(1, 'admin', 'HOST', 'admin@demo.com', 'Admin User', '$2a$10$k7/c7Hcs.rltqZSqFHeZdeSACn8Q4drncGFMy0z/HgBYHRviw4yh2', '', 'System administrator'),
(2, 'demo', 'USER', 'demo@demo.com', 'Demo User', '$2a$10$k7/c7Hcs.rltqZSqFHeZdeSACn8Q4drncGFMy0z/HgBYHRviw4yh2', '', 'Demo user account'),
(3, 'john', 'USER', 'john@demo.com', 'John Doe', '$2a$10$k7/c7Hcs.rltqZSqFHeZdeSACn8Q4drncGFMy0z/HgBYHRviw4yh2', '', 'Software developer');

-- Create sample memos
INSERT INTO memo (id, uid, creator_id, content, visibility, created_ts, updated_ts) VALUES
(1, 'memo_001', 1, '# Welcome to Memos!

This is your first memo. Memos supports **Markdown** formatting.

## Features
- Create and organize your notes
- Markdown support
- Tags and filters
- Attachments
- Export functionality

Try creating your own memo!', 'PUBLIC', strftime('%s', 'now'), strftime('%s', 'now')),

(2, 'memo_002', 1, '## Quick Start Guide

### Creating Memos
1. Click the "+" button
2. Write your content in Markdown
3. Add tags with `#tag`
4. Set visibility (Public/Private)
5. Save!

### Organizing
- Use tags to categorize: `#work` `#personal` `#ideas`
- Filter by date, tags, or content
- Pin important memos
- Archive completed items

#tutorial #getting-started', 'PUBLIC', strftime('%s', 'now'), strftime('%s', 'now')),

(3, 'memo_003', 2, '# My First Memo

Just testing out the memo functionality. This is pretty cool!

## Todo List
- [x] Create account
- [x] Write first memo
- [ ] Explore more features
- [ ] Invite team members

#personal #todo', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(4, 'memo_004', 2, '## Meeting Notes - Project Kickoff

**Date:** Today
**Participants:** Team leads, stakeholders

### Key Points
- Project timeline: 3 months
- Budget approved
- Weekly standups on Mondays
- Next milestone: Design review

### Action Items
- [ ] Create project roadmap
- [ ] Set up development environment
- [ ] Schedule design sessions

#work #meetings #project', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(5, 'memo_005', 3, '# Development Environment Setup

## Local Development
```bash
# Clone repository
git clone https://github.com/usememos/memos.git

# Start development environment
cd development
docker-compose up
```

## Database
- SQLite for local development
- PostgreSQL for production
- Automatic migrations

## Hot Reload
- Backend: Uses Air for Go hot reload
- Frontend: Vite dev server with HMR

#development #setup #docker', 'PUBLIC', strftime('%s', 'now'), strftime('%s', 'now')),

(6, 'memo_006', 3, '## Code Review Checklist

### Before Submitting
- [ ] Code follows style guide
- [ ] Tests are written and passing
- [ ] Documentation updated
- [ ] No console.log statements
- [ ] Error handling implemented

### Security
- [ ] Input validation
- [ ] Authentication checks
- [ ] No hardcoded secrets
- [ ] SQL injection prevention

### Performance
- [ ] Database queries optimized
- [ ] Large lists paginated
- [ ] Images optimized
- [ ] Bundle size acceptable

#development #code-review #checklist', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(7, 'memo_007', 1, '# Deployment Guide

## Production Deployment

### Docker Compose
```yaml
version: "3.8"
services:
  memos:
    image: neosmemo/memos:latest
    ports:
      - "5230:5230"
    volumes:
      - ./data:/var/opt/memos
    environment:
      - MEMOS_MODE=prod
      - MEMOS_DRIVER=postgres
      - MEMOS_DSN=postgresql://user:pass@db:5432/memos
```

### Environment Variables
- `MEMOS_MODE`: "dev" or "prod"
- `MEMOS_DRIVER`: "sqlite", "mysql", or "postgres"
- `MEMOS_DSN`: Database connection string

#deployment #docker #production', 'PUBLIC', strftime('%s', 'now'), strftime('%s', 'now')),

-- Sample memos with due dates for testing due date feature
(8, 'memo_008', 2, '## Project Presentation @due(2025-01-15)

Need to prepare the quarterly presentation for the stakeholders.

### Agenda Items
- [ ] Review Q4 metrics
- [ ] Prepare demo slides
- [ ] Practice presentation
- [ ] Send calendar invites

**Reminder:** Presentation is scheduled for January 15th!

#work #presentation #quarterly', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(9, 'memo_009', 3, '# Bug Fix Sprint @due(2025-01-10)

Critical bugs to fix before the next release:

## High Priority
- [ ] Fix login timeout issue @due(2025-01-08)
- [ ] Resolve database connection pooling @due(2025-01-09)  
- [ ] Memory leak in memo search @due(2025-01-10)

## Medium Priority
- [ ] UI alignment issues
- [ ] Improve error messages

The sprint deadline is January 10th. All critical bugs must be resolved by then.

#development #bugs #sprint', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(10, 'memo_010', 1, '## Team Meeting Follow-up @due(2025-01-12)

### Action Items from Today''s Meeting
- [ ] Update documentation @due(2025-01-11)
- [ ] Review code changes @due(2025-01-12)
- [ ] Schedule one-on-ones @due(2025-01-13)

### Notes
- Discussed new feature roadmap
- Decided on tech stack for next project
- Performance improvements needed

#meetings #team #action-items', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(11, 'memo_011', 2, '# Personal Tasks @due(2025-01-20)

## This Week
- [ ] Complete performance review @due(2025-01-14)
- [ ] Book vacation time @due(2025-01-16)
- [ ] Update LinkedIn profile @due(2025-01-18)

## Next Week  
- [ ] Dentist appointment @due(2025-01-20)
- [ ] Renew car insurance @due(2025-01-22)

Some personal tasks to keep track of with deadlines.

#personal #tasks #deadlines', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

(12, 'memo_012', 3, '## Security Audit @due(2025-01-25)

Annual security review and audit tasks:

### Immediate Actions
- [ ] Update all dependencies @due(2025-01-11)
- [ ] Review access permissions @due(2025-01-13)
- [ ] Scan for vulnerabilities @due(2025-01-15)

### Documentation
- [ ] Update security policies @due(2025-01-20)
- [ ] Create incident response plan @due(2025-01-22)
- [ ] Submit audit report @due(2025-01-25)

Critical security tasks with hard deadlines.

#security #audit #compliance', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now')),

-- Simple test memo with single due date
(13, 'memo_013', 1, 'Simple test memo @due(2025-01-16)', 'PUBLIC', strftime('%s', 'now'), strftime('%s', 'now')),

-- Test memo with due date in content body
(14, 'memo_014', 2, 'Remember to submit the quarterly report to finance department @due(2025-01-18) before the deadline.', 'PRIVATE', strftime('%s', 'now'), strftime('%s', 'now'));

-- Sample workspace settings
INSERT INTO system_setting (name, value, description) VALUES
('workspace-id', 'memos-dev', 'Development workspace identifier'),
('workspace-name', 'Memos Development', 'Development workspace name'),
('workspace-description', 'Development environment for Memos', 'Workspace description');

-- Sample user settings
INSERT INTO user_setting (user_id, key, value) VALUES
(1, 'locale', 'en'),
(1, 'theme', 'system'),
(1, 'memo-visibility', 'PRIVATE'),
(2, 'locale', 'en'),
(2, 'theme', 'light'),
(2, 'memo-visibility', 'PRIVATE'),
(3, 'locale', 'en'),
(3, 'theme', 'dark'),
(3, 'memo-visibility', 'PRIVATE');

-- Sample memo relations (linking memos)
INSERT INTO memo_relation (memo_id, related_memo_id, type) VALUES
(1, 2, 'REFERENCE'),
(2, 5, 'REFERENCE'),
(5, 6, 'REFERENCE'),
(6, 7, 'REFERENCE');

-- Sample reactions
INSERT INTO reaction (creator_id, content_id, reaction_type) VALUES
(2, 'memo_001', 'THUMBS_UP'),
(3, 'memo_001', 'HEART'),
(1, 'memo_003', 'THUMBS_UP'),
(3, 'memo_002', 'THUMBS_UP'),
(1, 'memo_005', 'HEART'),
(2, 'memo_007', 'THUMBS_UP');