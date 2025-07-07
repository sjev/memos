### Describe the solution you'd like

**As a** memos user
**I want** to set due dates on my memos
**So that** I can track time-sensitive notes and follow-up items

### Current Pain Points
- No way to track time-sensitive memos or follow-up items
- Difficult to identify overdue or upcoming tasks

### Type of feature

User Experience (UX)

### Additional context

I love this project and would like to contribute to this feature. While I'm a professional programmer, my expertise is unfortunately less relevant for this project (mainly Python and robotics). But I also see this as an opportunity to learn some Go/TS along the way.

Getting this feature done seems like a pretty invasive procedure. The chances are high that I'll mess up in the process. I'd appreciate help with making and reviewing an implementation plan (what to modify and how) from someone who has more experience with this project.

I understand that this feature has been requested multiple times before (#4583 , #4007, #3599, #2823), but was closed as "not planned" after being stale for a while.  This is another attempt to to get some progress here, hopefully with a better outcome.

## Proposed Solution
Add `@due(YYYY-MM-DD)` metadata syntax to memo content for tracking time-sensitive notes.

**Example:** `Meeting prep @due(2025-01-15)` or `- [ ] Task @due(2025-01-10)`

**Features:**
- Single "Due Date" filter shows all memos with due dates, sorted by date
- Color-coded badges indicate status (green/yellow/red for future/upcoming/overdue)
- Database-level filtering for performance

## Technical Implementation

### Backend Changes (Required)

The filtering system operates at the database level for performance. Due date properties must be detected server-side and stored in the memo payload, similar to existing `hasTaskList`, `hasLink`, etc.

#### Key Changes:
1. **Protocol Buffers**: Add `has_due_date` field to `MemoPayload.Property`
2. **Property Detection**: Extend `server/runner/memopayload/runner.go` to detect `@due()` patterns
3. **CEL Filters**: Add `has_due_date` attribute to `server/router/api/v1/memo_service_filter.go`
4. **Database Layer**: Update SQL templates in `store/db/*/memo_filter.go` for all database types

### Frontend Changes

1. **Due Date Parser**: Extract and validate due dates from memo content
2. **Filter System**: Add single "Due Date" filter to existing filter UI
3. **Content Renderer**: Display due dates as color-coded badges
4. **Sorting**: Sort filtered memos by due date

## Acceptance Criteria (MVP)

- [ ] Type `@due(2025-08-05)` in memo content
- [ ] Single "Due Date" filter shows all memos with due dates
- [ ] Filtered memos sorted by due date (earliest first)
- [ ] Due dates render as color-coded badges:
  - 🟢 Green: Due in future (>7 days)
  - 🟡 Yellow: Due within 7 days
  - 🔴 Red: Overdue
- [ ] Due date detection happens at memo create/update time
- [ ] Database-level filtering for performance

## Implementation Steps

### Backend
1. Add `has_due_date` field to Protocol Buffers
2. Implement due date detection in property runner
3. Add CEL filter attribute for `has_due_date`
4. Update database SQL templates

### Frontend
1. Create due date parser utility
2. Add "Due Date" filter to filter UI
3. Implement color-coded badge rendering
4. Add sorting by due date for filtered results

