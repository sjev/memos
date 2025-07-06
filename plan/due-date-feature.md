# GitHub Issue Content

see [Memos due date](https://github.com/usememos/memos/issues/4823)

---

# Due Date Feature (Minimal Tag-Based Implementation)

## User Story

**As a** memos user
**I want** to set due dates on my memos using a simple tag format
**So that** I can track time-sensitive notes and follow-up items effectively

### Current Pain Points
- No way to track time-sensitive memos or follow-up items
- Difficult to identify overdue or upcoming tasks
- Need simple solution without complex UI or database changes

### Proposed Solution
Use hashtag format `#due/YYYY-MM-DD` within memo content to indicate due dates, leveraging the existing tag system infrastructure.

## Detailed Requirements

### Core Functionality

#### 1. Due Date Tag Format
- **Tag syntax**: `#due/YYYY-MM-DD` within memo content
- **Parsing**: Leverage existing hashtag parsing infrastructure
- **Multiple dates**: Support multiple due dates per memo if needed
- **Hierarchical**: Uses existing `#parent/child` tag structure

#### 2. Visual Indicators
- **Due date badge**: Parse and display due date inline with content
- **Status indicators**:
  - Green: Due in future (>7 days)
  - Yellow: Due within 7 days
  - Red: Overdue

#### 3. Filtering System
- **Due date filter**: Show only memos containing due date tags
- **Overdue filter**: Show only memos with overdue dates
- **Due this week**: Show memos due within 7 days

### User Interface Specifications

#### 1. Memo Content
- **Tag rendering**: `#due/2025-08-05` displays as styled badge
- **Status styling**: Color-coded based on due date status
- **Tooltip**: Show relative time on hover ("Due in 3 days")

#### 2. Filter UI
- **Filter chips**: Add "Due Date", "Overdue", "Due This Week" options
- **Combined filters**: Work with existing tag and content filters
- **Filter count**: Show count of memos matching due date filters


### Technical Requirements

#### 1. Tag System Extension
- **Tag pattern**: `#due/YYYY-MM-DD` using existing hashtag infrastructure
- **Date extraction**: Parse date from tag content after `#due/` prefix
- **Validation**: Ensure extracted dates are valid

#### 2. Frontend Integration
- **FilterFactor enum**: Add due date filter options
- **Content renderer**: Update memo display to show due date badges
- **Filter system**: Extend existing filter logic

#### 3. Performance Considerations
- **Existing tag infrastructure**: Leverages existing tag parsing and filtering
- **Tag indexing**: Benefits from existing tag performance optimizations
- **No backend changes**: Uses existing tag system entirely

## Acceptance Criteria

### Must Have (MVP)
- [ ] Type `#due/2025-08-05` in memo content
- [ ] Due date renders as colored badge inline with content
- [ ] Filter memos by "Due Date" to show only memos with due dates
- [ ] Filter memos by "Overdue" to show only overdue memos
- [ ] Filter memos by "Due This Week" to show upcoming due dates

### Should Have (Phase 2)
- [ ] Tooltip showing relative time ("Due in 3 days")
- [ ] Support multiple due dates per memo
- [ ] Tag auto-completion for `#due/` prefix

### Could Have (Future)
- [ ] Auto-complete for due date format in editor
- [ ] Due date notifications/reminders
- [ ] Sort memos by due date
- [ ] Calendar integration with due date visualization

## Success Metrics
- Users can successfully add due dates using tag format
- Filter performance remains acceptable with content parsing
- Visual indicators clearly communicate due date status
- Feature adoption rate among existing users

## Implementation Plan

### Phase 1: Core Functionality (0.5-1 day)
1. **Tag System Extension**
   - Extend existing tag renderer to detect `#due/` prefix
   - Extract and validate date from tag content
   - Calculate due date status (overdue, upcoming, future)

2. **Visual Styling**
   - Add status-based styling for due date tags (red, yellow, green)
   - Ensure consistent styling with existing tag system

3. **Filter Integration**
   - Extend existing tag filtering to support due date filters
   - Add due date filter logic using existing `tagSearch` infrastructure

### Phase 2: Polish & Enhancement (0.5 day)
1. **Visual Improvements**
   - Add hover tooltips with relative time
   - Refine badge styling and positioning

2. **Filter UI**
   - Add due date filter chips to existing filter bar
   - Update filter combinations

## Technical Implementation

### Frontend Changes Only

#### 1. Tag System Extension
**File:** `web/src/components/MemoContent/Tag.tsx`
```typescript
// Extend existing tag component to handle due date tags
export function isDueDateTag(tag: string): boolean {
  return tag.startsWith('due/') && /due\/\d{4}-\d{2}-\d{2}/.test(tag);
}

export function parseDueDateFromTag(tag: string): Date | null {
  const match = tag.match(/due\/(\d{4}-\d{2}-\d{2})/);
  if (!match) return null;
  
  const date = new Date(match[1]);
  return isNaN(date.getTime()) ? null : date;
}

export function getDueDateStatus(date: Date): 'overdue' | 'upcoming' | 'future' {
  const now = new Date();
  const diffDays = Math.ceil((date.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));
  
  if (diffDays < 0) return 'overdue';
  if (diffDays <= 7) return 'upcoming';
  return 'future';
}
```

#### 2. Filter System Extension
**File:** `web/src/store/v2/memoFilter.ts`
```typescript
// Extend existing filter factors
export type FilterFactor =
  | "tagSearch"
  | "visibility"
  | "contentSearch"
  | "displayTime"
  | "dueDate"           // New filter type
  | "overdueMemos"      // New filter type
  | "dueSoon"          // New filter type
  | "pinned"
  | "property.hasLink"
  | "property.hasTaskList"
  | "property.hasCode";

// Add due date filtering logic that works with existing tag system
export function filterMemosByDueDate(memos: Memo[], filterType: 'dueDate' | 'overdueMemos' | 'dueSoon'): Memo[] {
  return memos.filter(memo => {
    const tags = extractTagsFromMemo(memo); // Use existing tag extraction
    const dueDateTags = tags.filter(tag => isDueDateTag(tag));
    
    if (dueDateTags.length === 0) return filterType === 'dueDate' ? false : false;
    
    const dueDates = dueDateTags.map(tag => parseDueDateFromTag(tag)).filter(Boolean);
    // Filter logic based on filterType...
  });
}
```

#### 3. Tag Renderer Updates
**File:** `web/src/components/MemoContent/Tag.tsx`
```typescript
// Extend existing Tag component to handle due date styling
const Tag: React.FC<{ tag: string }> = ({ tag }) => {
  const isDueDate = isDueDateTag(tag);
  
  if (isDueDate) {
    const date = parseDueDateFromTag(tag);
    const status = date ? getDueDateStatus(date) : 'future';
    
    return (
      <span className={`tag due-date-tag ${status}`}>
        #{tag}
      </span>
    );
  }
  
  // Existing tag rendering logic...
};
```

#### 4. Filter UI Components
**File:** `web/src/components/MemoFilters.tsx`
- Add "Due Date", "Overdue", "Due Soon" filter chips
- Leverage existing filter UI patterns and styling

### No Backend Changes Required
- **Database:** No schema changes needed
- **API:** No new endpoints or modifications
- **Protocol Buffers:** No changes required
- **Tag System:** Leverages existing hashtag infrastructure completely

### Testing Strategy
- **Unit tests:** Due date tag parsing and validation
- **Component tests:** Tag rendering with due date styling
- **Integration tests:** Filter functionality with existing tag system

### Estimated Development Time
- **Phase 1:** 0.5-1 day
- **Phase 2:** 0.5 day
- **Testing:** 0.5 day

**Total:** 1-2 days for complete implementation
