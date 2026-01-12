-- Sample Data for Task Tracking System
-- This demonstrates the example from the requirements:
-- - 3 people: Ricardo, Shanaya, Daniel
-- - Task 1: Monthly, 12 occurrences
-- - Task 2: Once, 1 occurrence
-- - Task 3: Daily, 30 occurrences

-- Insert People
INSERT INTO "people" ("id", "name", "email", "active") VALUES
  ('11111111-1111-1111-1111-111111111111', 'Ricardo', 'ricardo@example.com', true),
  ('22222222-2222-2222-2222-222222222222', 'Shanaya', 'shanaya@example.com', true),
  ('33333333-3333-3333-3333-333333333333', 'Daniel', 'daniel@example.com', true);

-- Insert Tasks (dimension/templates)
INSERT INTO "tasks" ("id", "title", "description", "recurrence_type", "max_occurrences") VALUES
  ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 'Monthly Report', 'Generate and submit monthly performance report', 'monthly', 12),
  ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'Annual Review', 'Conduct annual team performance review', 'once', 1),
  ('cccccccc-cccc-cccc-cccc-cccccccccccc', 'Daily Standup', 'Daily team standup meeting', 'daily', 30);

-- Insert Task Occurrences for Task 1 (Monthly Report - 12 occurrences)
-- Starting January 2024, due on the 1st of each month
INSERT INTO "task_occurrences" ("id", "task_id", "occurrence_number", "due_date", "status", "completed_at") VALUES
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 1, '2024-01-01', 'completed', '2024-01-01 14:30:00'),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 2, '2024-02-01', 'completed', '2024-02-01 16:45:00'),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 3, '2024-03-01', 'completed', '2024-03-01 10:20:00'),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 4, '2024-04-01', 'in_progress', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 5, '2024-05-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 6, '2024-06-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 7, '2024-07-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 8, '2024-08-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 9, '2024-09-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 10, '2024-10-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 11, '2024-11-01', 'not_started', NULL),
  (gen_random_uuid(), 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', 12, '2024-12-01', 'not_started', NULL);

-- Insert Task Occurrence for Task 2 (Annual Review - 1 occurrence)
INSERT INTO "task_occurrences" ("id", "task_id", "occurrence_number", "due_date", "status", "completed_at") VALUES
  (gen_random_uuid(), 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 1, '2024-12-15', 'not_started', NULL);

-- Insert Task Occurrences for Task 3 (Daily Standup - 30 occurrences)
-- Starting January 1, 2024, for 30 consecutive days
INSERT INTO "task_occurrences" ("id", "task_id", "occurrence_number", "due_date", "status", "completed_at") VALUES
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 1, '2024-01-01', 'completed', '2024-01-01 09:15:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 2, '2024-01-02', 'completed', '2024-01-02 09:12:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 3, '2024-01-03', 'completed', '2024-01-03 09:18:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 4, '2024-01-04', 'completed', '2024-01-04 09:10:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 5, '2024-01-05', 'completed', '2024-01-05 09:20:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 6, '2024-01-06', 'completed', '2024-01-06 09:14:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 7, '2024-01-07', 'completed', '2024-01-07 09:16:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 8, '2024-01-08', 'completed', '2024-01-08 09:11:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 9, '2024-01-09', 'completed', '2024-01-09 09:13:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 10, '2024-01-10', 'completed', '2024-01-10 09:17:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 11, '2024-01-11', 'completed', '2024-01-11 09:15:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 12, '2024-01-12', 'completed', '2024-01-12 09:19:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 13, '2024-01-13', 'completed', '2024-01-13 09:12:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 14, '2024-01-14', 'completed', '2024-01-14 09:14:00'),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 15, '2024-01-15', 'in_progress', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 16, '2024-01-16', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 17, '2024-01-17', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 18, '2024-01-18', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 19, '2024-01-19', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 20, '2024-01-20', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 21, '2024-01-21', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 22, '2024-01-22', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 23, '2024-01-23', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 24, '2024-01-24', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 25, '2024-01-25', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 26, '2024-01-26', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 27, '2024-01-27', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 28, '2024-01-28', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 29, '2024-01-29', 'not_started', NULL),
  (gen_random_uuid(), 'cccccccc-cccc-cccc-cccc-cccccccccccc', 30, '2024-01-30', 'not_started', NULL);

-- Insert Assignments
-- Note: We need to use a subquery to get the occurrence IDs since we used gen_random_uuid()
-- For demonstration, let's assign people to specific occurrences by task and occurrence number

-- Monthly Report assignments (alternating between Ricardo and Shanaya)
INSERT INTO "task_assignments" ("task_occurrence_id", "person_id")
SELECT to_.id, '11111111-1111-1111-1111-111111111111' -- Ricardo
FROM "task_occurrences" to_
WHERE to_.task_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  AND to_.occurrence_number IN (1, 3, 5, 7, 9, 11);

INSERT INTO "task_assignments" ("task_occurrence_id", "person_id")
SELECT to_.id, '22222222-2222-2222-2222-222222222222' -- Shanaya
FROM "task_occurrences" to_
WHERE to_.task_id = 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa'
  AND to_.occurrence_number IN (2, 4, 6, 8, 10, 12);

-- Annual Review assignment (all three people working together)
INSERT INTO "task_assignments" ("task_occurrence_id", "person_id")
SELECT to_.id, p.id
FROM "task_occurrences" to_
CROSS JOIN "people" p
WHERE to_.task_id = 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb';

-- Daily Standup assignments (all three people for each standup)
INSERT INTO "task_assignments" ("task_occurrence_id", "person_id")
SELECT to_.id, p.id
FROM "task_occurrences" to_
CROSS JOIN "people" p
WHERE to_.task_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc';

