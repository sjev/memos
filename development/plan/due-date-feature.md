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

## Status

✅ **Core Filtering System - COMPLETE**
- Backend due date detection and storage (`@due(YYYY-MM-DD)` pattern)
- Database-level filtering for all supported databases
- Frontend filter UI with statistics display
- CEL expression integration

🔄 **Phase 2: Due Date Storage & Display - IN PROGRESS**
- Store actual due date values in backend (not just boolean)
- Color-coded due date badges in memo content
- Sort filtered memos by due date
- Due date extraction utilities

## Implementation Plan: Phase 2

### Backend Changes

**1. Protocol Buffers Extension**
- Add `due_date` field (string, ISO date format) to `MemoPayload.Property`
- Keep existing `has_due_date` boolean for filtering
- File: `proto/api/v1/memo_payload.proto` or similar

**2. Property Runner Enhancement**
- Extend `server/runner/memopayload/runner.go` to extract actual due date values
- Parse all `@due(YYYY-MM-DD)` patterns and store earliest date
- Logic: Multiple due dates → use earliest one
- Set both `has_due_date=true` and `due_date="2025-01-15"`

**3. Database Schema Considerations**
- Due dates stored in JSON payload (no schema changes needed)
- Sorting handled via JSON extraction in queries
- Add sorting support to existing memo listing endpoints

### Frontend Changes

**4. Due Date Utilities**
- Create `utils/dueDateUtils.ts` for date parsing and status calculation
- Functions: `getDueDateStatus()`, `formatDueDate()`, `parseDueDates()`
- Status calculation: overdue, upcoming (≤7 days), future

**5. Badge Component**
- Create `DueDateBadge.tsx` component with color coding:
  - 🔴 Red: Overdue (past due date)
  - 🟡 Yellow: Due within 7 days
  - 🟢 Green: Due in future (>7 days)
- Include calendar icon and formatted date

**6. Content Rendering Integration**
- Identify memo content renderer component
- Integrate badge rendering for `@due()` patterns
- Replace text patterns with interactive badges

**7. Sorting Enhancement**
- Add due date sorting to memo list queries
- Update UI to show "sorted by due date" when filter active
- Earliest due dates appear first

### Technical Notes
- **Multiple due dates**: Extract all dates, store earliest one
- **Date validation**: Only accept valid YYYY-MM-DD format
- **Timezone handling**: Use local date comparison (no time component)
- **Performance**: Leverage existing JSON extraction patterns in database queries

## Acceptance Criteria (MVP)

- [x] Type `@due(2025-08-05)` in memo content
- [x] Single "Due Date" filter shows all memos with due dates
- [x] Due date detection happens at memo create/update time
- [x] Database-level filtering for performance
- [ ] Due dates render as color-coded badges:
  - 🟢 Green: Due in future (>7 days)
  - 🟡 Yellow: Due within 7 days
  - 🔴 Red: Overdue
- [ ] Filtered memos sorted by due date (earliest first)

