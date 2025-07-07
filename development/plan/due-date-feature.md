# Due Date Feature (Metadata-Based Implementation)


see [GitHub feature issue](https://github.com/usememos/memos/issues/4823)

## User Story

**As a** memos user
**I want** to set due dates on my memos using metadata syntax
**So that** I can track time-sensitive notes without polluting the tag namespace

### Current Pain Points
- No way to track time-sensitive memos or follow-up items
- Difficult to identify overdue or upcoming tasks
- Tags are meant for topical organization, not temporal metadata

## Proposed Solution
Use `@due(YYYY-MM-DD)` metadata syntax within memo content, following the same pattern as existing todo tasks.


Example Usage

```markdown
Meeting prep @due(2025-01-15)
Follow up with client @due(2025-01-20)
Review quarterly report @due(2025-01-31)

Project planning notes #work #planning
- [ ] Define requirements @due(2025-01-10)
- [ ] Design mockups @due(2025-01-15)
- [ ] Implementation @due(2025-01-30)
```



### Core Functionality

#### 1. Due Date Syntax
- **Format**: `@due(YYYY-MM-DD)` within memo content
- **Multiple dates**: Support multiple due dates per memo
- **Validation**: Ensure dates are valid and properly formatted

#### 2. Visual Indicators
- **Due date badge**: Parse and display due date inline with content
- **Status indicators**:
  - Green: Due in future (>7 days)
  - Yellow: Due within 7 days
  - Red: Overdue

#### 3. Filtering System
- **Property filters**: `property.hasDueDate`, `property.isOverdue`, `property.dueSoon`
- **Combined filters**: Work with existing tag and content filters
- **Filter count**: Show count of matching memos

### User Interface

#### 1. Memo Content
- **Metadata rendering**: `@due(2025-08-05)` displays as styled badge
- **Status styling**: Color-coded based on due date status
- **Tooltip**: Show relative time on hover ("Due in 3 days")

#### 2. Filter UI
- **Filter chips**: Add "Due Date", "Overdue", "Due Soon" options
- **Filter integration**: Work with existing filter system

## Technical Implementation

### Frontend Changes Only

#### 1. Due Date Parser
**File:** `web/src/utils/dueDateParser.ts`
```typescript
export function extractDueDates(content: string): Date[] {
  const dueDateRegex = /@due\((\d{4}-\d{2}-\d{2})\)/g;
  const matches = [...content.matchAll(dueDateRegex)];
  return matches.map(match => new Date(match[1])).filter(date => !isNaN(date.getTime()));
}

export function getDueDateStatus(date: Date): 'overdue' | 'upcoming' | 'future' {
  const now = new Date();
  const diffDays = Math.ceil((date.getTime() - now.getTime()) / (1000 * 60 * 60 * 24));

  if (diffDays < 0) return 'overdue';
  if (diffDays <= 7) return 'upcoming';
  return 'future';
}
```

#### 2. Memo Property Detection
**File:** `web/src/utils/memoProperties.ts`
```typescript
interface MemoProperties {
  hasTaskList: boolean;
  hasDueDate: boolean;      // New property
  hasIncompleteTasks: boolean;
}

export function detectMemoProperties(content: string): MemoProperties {
  const dueDates = extractDueDates(content);

  return {
    ...existingProperties,
    hasDueDate: dueDates.length > 0,
  };
}
```

#### 3. Filter System Extension
**File:** `web/src/store/v2/memoFilter.ts`
```typescript
export type FilterFactor =
  | "tagSearch"
  | "visibility"
  | "contentSearch"
  | "displayTime"
  | "property.hasTaskList"
  | "property.hasDueDate"      // New filter
  | "property.isOverdue"       // New filter
  | "property.dueSoon"         // New filter
  | "pinned"
  | "property.hasLink"
  | "property.hasCode";
```

#### 4. Content Renderer
**File:** `web/src/components/MemoContent/DueDate.tsx`
```typescript
const DueDate: React.FC<{ date: Date }> = ({ date }) => {
  const status = getDueDateStatus(date);
  const relativeTime = formatRelativeTime(date);

  return (
    <span className={`due-date-badge ${status}`} title={relativeTime}>
      @due({formatDate(date)})
    </span>
  );
};
```


## Acceptance Criteria

### Must Have (MVP)
- [ ] Type `@due(2025-08-05)` in memo content
- [ ] Filter memos by "Due Date" to show only memos with due dates
- [ ] Filter memos by "Overdue" to show only overdue memos
- [ ] Filter memos by "Due Soon" to show upcoming due dates

### Should Have (Phase 2)
- [ ] Due date renders as colored badge inline with content
- [ ] Tooltip showing relative time ("Due in 3 days")
- [ ] Support multiple due dates per memo
- [ ] Auto-completion for `@due()` syntax
- [ ] Sort memos by due date

### Could Have (Future)
- [ ] Due date notifications/reminders
- [ ] Calendar integration
- [ ] Additional metadata (`@reminder()`, `@priority()`)


