-- Task Tracking Data Model
-- This schema supports recurring tasks with assignments and status tracking

-- People who can be assigned to tasks
CREATE TABLE "people" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "name" varchar(255) NOT NULL,
  "email" varchar(255),
  "active" boolean DEFAULT true,
  "created_at" timestamp DEFAULT (now())
);

-- Task definitions (templates for recurring work)
CREATE TABLE "tasks" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "title" varchar(255) NOT NULL,
  "description" text,
  "recurrence_type" varchar(20) NOT NULL CHECK (recurrence_type IN ('once', 'daily', 'weekly', 'monthly')),
  "max_occurrences" integer NOT NULL CHECK (max_occurrences > 0),
  "created_at" timestamp DEFAULT (now())
);

-- Individual instances of tasks (fact table)
CREATE TABLE "task_occurrences" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "task_id" uuid NOT NULL,
  "occurrence_number" integer NOT NULL CHECK (occurrence_number > 0),
  "due_date" timestamp NOT NULL,
  "status" varchar(20) NOT NULL DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'completed')),
  "completed_at" timestamp,
  "created_at" timestamp DEFAULT (now()),
  CONSTRAINT "fk_task_occurrences_task" FOREIGN KEY ("task_id") REFERENCES "tasks"("id") ON DELETE CASCADE,
  CONSTRAINT "unique_task_occurrence" UNIQUE ("task_id", "occurrence_number")
);

-- Assignments linking people to task occurrences (many-to-many)
CREATE TABLE "task_assignments" (
  "id" uuid PRIMARY KEY DEFAULT (gen_random_uuid()),
  "task_occurrence_id" uuid NOT NULL,
  "person_id" uuid NOT NULL,
  "assigned_at" timestamp DEFAULT (now()),
  CONSTRAINT "fk_task_assignments_occurrence" FOREIGN KEY ("task_occurrence_id") REFERENCES "task_occurrences"("id") ON DELETE CASCADE,
  CONSTRAINT "fk_task_assignments_person" FOREIGN KEY ("person_id") REFERENCES "people"("id") ON DELETE CASCADE,
  CONSTRAINT "unique_assignment" UNIQUE ("task_occurrence_id", "person_id")
);

-- Indexes for common query patterns
CREATE INDEX "idx_task_occurrences_task_id" ON "task_occurrences"("task_id");
CREATE INDEX "idx_task_occurrences_due_date" ON "task_occurrences"("due_date");
CREATE INDEX "idx_task_occurrences_status" ON "task_occurrences"("status");
CREATE INDEX "idx_task_assignments_occurrence_id" ON "task_assignments"("task_occurrence_id");
CREATE INDEX "idx_task_assignments_person_id" ON "task_assignments"("person_id");

-- Comments for documentation
COMMENT ON TABLE "people" IS 'Individuals who can be assigned to complete tasks';
COMMENT ON TABLE "tasks" IS 'Task templates defining recurring work patterns';
COMMENT ON TABLE "task_occurrences" IS 'Individual instances of tasks with status tracking';
COMMENT ON TABLE "task_assignments" IS 'Many-to-many relationship between people and task occurrences';

COMMENT ON COLUMN "tasks"."recurrence_type" IS 'Frequency of task recurrence: once, daily, weekly, or monthly';
COMMENT ON COLUMN "tasks"."max_occurrences" IS 'Total number of times this task should occur';
COMMENT ON COLUMN "task_occurrences"."occurrence_number" IS 'Sequential number of this occurrence (1 to max_occurrences)';
COMMENT ON COLUMN "task_occurrences"."status" IS 'Current status: not_started, in_progress, or completed';

