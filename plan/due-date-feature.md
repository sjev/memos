# Due Date Feature

## User Story

**As a** memos user
**I want** to set optional due dates on my memos and visualize them in the calendar
**So that** I can track time-sensitive notes and follow-up items effectively

### Current Pain Points
- No way to track time-sensitive memos or follow-up items
- Calendar only shows creation dates, not when action is needed
- Difficult to identify overdue or upcoming tasks

### Proposed Solution
Add optional due date functionality with filtering and calendar visualization capabilities.

## Detailed Requirements

### Core Functionality

#### 1. Due Date Management
- **Add due date**: Set optional due date when creating new memos
- **Edit due date**: Modify existing due dates on any memo
- **Remove due date**: Clear due date from memos
- **Due date format**: Date-only (no time component needed initially)

#### 2. Visual Indicators
- **Due date display**: Show due date in memo view alongside creation date
- **Overdue indication**: Visual cue for memos past their due date
- **Upcoming indication**: Highlight memos due within next 7 days

#### 3. Filtering System
- **Due date filter**: New filter button to show only memos with due dates
- **Overdue filter**: Show only memos past their due date

### User Interface Specifications

#### 1. Memo Editor
- **Due date picker**: Date input field in memo editor
- **Clear option**: Easy way to remove due date

#### 2. Memo Display
- **Due date badge**: Visual indicator showing due date
- **Status indicators**:
  - Green: Due in future
  - Yellow: Due within 7 days
  - Red: Overdue

#### 3. Filter UI
- **Due date filter chip**: Similar to existing "todo" and "code" filters
- **Overdue filter chip**: Show only overdue memos
- **Combined filters**: Work with existing filters (tags, visibility, etc.)


### Technical Requirements

#### 1. Data Model Changes
- Add `due_date` field to Memo protobuf (optional timestamp)
- Update database schema with `due_date` column
- Maintain backward compatibility with existing memos

#### 2. API Enhancements
- Support due date in CreateMemo and UpdateMemo operations
- Add due date filtering to ListMemos
- Include due date in search/filter queries

#### 3. Frontend Integration
- Extend existing FilterFactor enum with due date options
- Update MemoView component to display due dates
- Add due date input to MemoEditor

#### 4. Performance Considerations
- Index due_date column for efficient filtering
- Optimize queries for overdue memo retrieval

## Acceptance Criteria

### Must Have (MVP)
- [ ] Add due date when creating new memos
- [ ] Edit/remove due date on existing memos
- [ ] Display due date in memo view with visual status indicators
- [ ] Filter memos by presence of due date
- [ ] Filter by overdue memos

### Should Have (Phase 2)
- [ ] Quick date selection shortcuts in editor
- [ ] Relative time display ("Due in 3 days")
- [ ] Sort memos by due date

### Could Have (Future)
- [ ] Calendar integration with due date visualization
- [ ] Due date notifications/reminders
- [ ] Bulk due date operations
- [ ] Integration with external calendar systems

## Success Metrics
- Users can successfully set and modify due dates
- Filter performance remains acceptable with due date queries
- Visual indicators clearly communicate due date status
- Feature adoption rate among existing users

## Implementation Phases

### Phase 1: Core Infrastructure
1. Database schema updates
2. Protocol buffer changes
3. Basic API support

### Phase 2: Frontend Integration
1. Due date input in memo editor
2. Display in memo view
3. Basic filtering

### Phase 3: Polish & Enhancement
1. Status indicators and visual cues
2. Performance optimizations

## Technical Implementation Plan

### Backend Changes

#### 1. Protocol Buffer Updates
**File:** `proto/api/v1/memo_service.proto`
```protobuf
message Memo {
  // ... existing fields ...
  optional google.protobuf.Timestamp due_date = 19;  // New due date field
}
```

#### 2. Database Schema Migration
**File:** `store/migration/sqlite/LATEST.sql`
```sql
-- Add due_date column to memo table
ALTER TABLE memo ADD COLUMN due_date BIGINT DEFAULT NULL;
-- Add index for efficient due date filtering
CREATE INDEX idx_memo_due_date ON memo(due_date) WHERE due_date IS NOT NULL;
```

#### 3. Store Layer Updates
**File:** `store/memo.go`
- Add due_date field to Memo struct
- Update CreateMemo and UpdateMemo methods
- Add due date filtering to ListMemos query builder

#### 4. API Service Updates
**File:** `server/router/api/v1/memo_service.go`
- Handle due_date in CreateMemo and UpdateMemo requests
- Add due date validation (must be in future when set)
- Support due date filtering in ListMemos

### Frontend Changes

#### 1. Type Definitions
**File:** `web/src/types/proto/api/v1/memo_service.ts`
- Generated types will include due_date field automatically

#### 2. Filter System Extension
**File:** `web/src/store/v2/memoFilter.ts`
```typescript
export type FilterFactor =
  | "tagSearch"
  | "visibility"
  | "contentSearch"
  | "displayTime"
  | "dueDate"           // New filter type
  | "overdueMemos"      // New filter type
  | "pinned"
  | "property.hasLink"
  | "property.hasTaskList"
  | "property.hasCode";
```

#### 3. Memo Editor Enhancement
**File:** `web/src/components/MemoEditor/MemoEditor.tsx`
- Add due date picker component
- Include due date in memo creation/update logic

#### 4. Memo Display Updates
**File:** `web/src/components/MemoView.tsx`
- Display due date alongside creation date
- Add visual status indicators (colors for overdue/upcoming)

#### 5. Filter UI Components
**File:** `web/src/components/MemoFilters.tsx`
- Add due date filter chips
- Add overdue filter chip
- Maintain existing filter combinations


### Implementation Dependencies

#### Required Libraries
- **Backend:** No new dependencies (uses existing protobuf/database libraries)
- **Frontend:** Use native HTML5 date input for simplicity

#### Database Considerations
- **Migration strategy:** Use existing migration system
- **Backward compatibility:** Due date is optional, existing memos unaffected
- **Performance:** Index on due_date column for efficient filtering
- **Multi-database support:** Ensure migration works with SQLite, MySQL, PostgreSQL

#### Testing Requirements
- **Unit tests:** Due date validation, filtering logic
- **Integration tests:** API endpoints with due date operations
- **Frontend tests:** Component behavior with due dates
- **Migration tests:** Database schema updates

### Risk Mitigation

#### Potential Issues
1. **Performance impact:** Due date filtering on large datasets
   - **Solution:** Database indexing and query optimization
2. **Calendar complexity:** Dual-mode display may confuse users
   - **Solution:** Clear UI indicators and smooth transitions
3. **Timezone handling:** Due dates across different user timezones
   - **Solution:** Store as UTC, display in user's local timezone
4. **Data migration:** Adding due date to existing memos
   - **Solution:** Gradual rollout with proper migration scripts

#### Rollback Strategy
- Database migration can be reversed if needed
- Feature flags to enable/disable due date functionality
- Progressive rollout to subset of users initially

### Estimated Development Time
- **Phase 1 (Backend):** 2-3 days
- **Phase 2 (Frontend Core):** 3-4 days
- **Phase 3 (Polish):** 1-2 days
- **Testing & Bug fixes:** 1-2 days

**Total:** 7-11 days for complete implementation
