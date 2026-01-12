# Task Tracking Data Model - Design Discussion

## Overview
This data model supports tracking recurring tasks with assignments and status tracking over time.

## Schema Design

### Dimensional Model Approach
We've structured this as a dimensional model:

**Dimensions (descriptive, relatively static):**
- `people` - Individuals who can be assigned work
- `tasks` - Task templates/definitions with recurrence rules

**Facts (events, transactions):**
- `task_occurrences` - Individual instances of tasks with status and dates
- `task_assignments` - Many-to-many relationship linking people to task occurrences

### Key Design Decisions

#### 1. Separation of Tasks and Task Occurrences
**Decision:** Tasks are templates; occurrences are individual instances.

**Rationale:**
- A task like "Monthly Report" is defined once with recurrence rules
- Each month generates a separate occurrence with its own status and assignments
- This allows tracking progress on individual instances while maintaining the task definition

**Example:**
```
Task: "Monthly Report" (recurrence: monthly, max_occurrences: 12)
  → Task Occurrence 1 (January, status: completed)
  → Task Occurrence 2 (February, status: in_progress)
  → Task Occurrence 3 (March, status: not_started)
  ...
```

#### 2. Occurrence Generation Strategy
**Decision:** Generate all occurrences upfront when a task is created.

**Rationale:**
- Simpler to query and manage
- Easier to assign people to future occurrences
- Clear visibility into all planned work
- Avoids complex date calculation logic in queries

**Alternative Considered:** Dynamic generation based on recurrence rules
- More flexible but adds query complexity
- Harder to pre-assign people to future occurrences

#### 3. Assignment Tracking
**Decision:** Track only current assignments (no history).

**Rationale:**
- Keeps the model simple
- Meets the stated requirements
- Sufficient for most use cases

**Future Enhancement:** If reassignment tracking is needed, we could:
- Add `unassigned_at` timestamp to track when assignments end
- Create an `assignment_history` table
- Add `assigned_by` field to track who made the assignment

**Use Case for History:** If tasks can be reassigned and we need to know:
- Who was originally assigned
- When reassignments happened
- Who made the reassignment decision

#### 4. Many-to-Many Assignments
**Decision:** Allow multiple people to be assigned to a single task occurrence.

**Rationale:**
- The prompt states "people can be assigned" (plural)
- Real-world tasks often require collaboration
- Junction table (`task_assignments`) provides flexibility

**Example:**
```
Task Occurrence: "Q1 Planning" (due: 2024-03-31)
  → Assigned to: Ricardo
  → Assigned to: Shanaya
```

#### 5. Status Tracking
**Decision:** Status belongs to occurrences, not tasks.

**Rationale:**
- Explicitly stated in requirements
- Each occurrence can progress independently
- Task definition remains unchanged

**Status Values:**
- `not_started` - Work hasn't begun
- `in_progress` - Currently being worked on
- `completed` - Finished (tracked with `completed_at` timestamp)

#### 6. Due Dates
**Decision:** Each occurrence has a `due_date` field.

**Rationale:**
- Essential for scheduling and prioritization
- Allows queries like "what's due this week?"
- For daily tasks over 30 days, each occurrence knows its specific day

**Calculation Example:**
```
Task: "Daily Standup" (recurrence: daily, max_occurrences: 30, start: 2024-01-01)
  → Occurrence 1: due_date = 2024-01-01
  → Occurrence 2: due_date = 2024-01-02
  → Occurrence 3: due_date = 2024-01-03
  ...
```

## Example Data

### Scenario from Requirements

**People:**
- Ricardo
- Shanaya
- Daniel

**Tasks:**
1. Task 1: Monthly task, 12 occurrences
2. Task 2: One-time task
3. Task 3: Daily task, 30 occurrences

**Sample Queries:**

```sql
-- Get all overdue tasks assigned to Ricardo
SELECT 
  t.title,
  to_.occurrence_number,
  to_.due_date,
  to_.status
FROM task_occurrences to_
JOIN tasks t ON to_.task_id = t.id
JOIN task_assignments ta ON to_.id = ta.task_occurrence_id
JOIN people p ON ta.person_id = p.id
WHERE p.name = 'Ricardo'
  AND to_.status != 'completed'
  AND to_.due_date < NOW();

-- Get completion rate for a task
SELECT 
  t.title,
  COUNT(*) FILTER (WHERE to_.status = 'completed') AS completed,
  COUNT(*) AS total,
  ROUND(100.0 * COUNT(*) FILTER (WHERE to_.status = 'completed') / COUNT(*), 2) AS completion_rate
FROM tasks t
JOIN task_occurrences to_ ON t.id = to_.task_id
GROUP BY t.id, t.title;
```

## Schema Strengths

1. **Clear separation of concerns** - Tasks vs. occurrences
2. **Flexible assignments** - Many-to-many relationship
3. **Audit trail** - Created/completed timestamps
4. **Data integrity** - Foreign keys, check constraints, unique constraints
5. **Query performance** - Indexes on common access patterns
6. **Extensibility** - Easy to add fields like priority, tags, etc.

## Potential Extensions

If requirements evolve, this model could support:
- Task dependencies (occurrence A must complete before B starts)
- Subtasks (hierarchical task breakdown)
- Assignment history (who was assigned when)
- Comments/notes on occurrences
- File attachments
- Notifications/reminders
- Custom recurrence patterns (e.g., "every 2 weeks")
- Task templates/categories

