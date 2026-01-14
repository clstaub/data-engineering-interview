-- FHIR SQL Queries
-- Answers to the 10 SQL questions from the interview prompt

-- ============================================================================
-- BEGINNER QUESTIONS
-- ============================================================================

-- Question 1: Retrieve all active patients
SELECT
  id,
  identifier,
  name,
  gender,
  birth_date,
  telecom
FROM "Patient"
WHERE active = true;


-- Question 2: Find encounters for a specific patient
SELECT
  e.patient_id,
  e.status,
  e.encounter_date
FROM "Encounter" e
WHERE e.patient_id = 'bde4bb68-ffa6-4568-9b7b-1e3a6886dd30'; -- Replace with any patient ID


-- Question 3: List all observations recorded for a patient
SELECT
	o.type,
	o.value,
	o.unit,
	o.recorded_at
FROM "Observation" o
WHERE o.patient_id = 'bde4bb68-ffa6-4568-9b7b-1e3a6886dd30'; -- Replace with any patient ID


-- ============================================================================
-- INTERMEDIATE QUESTIONS
-- ============================================================================

-- Question 4: Find the most recent encounter for each patient
WITH most_recent_encounters AS (
  SELECT
    patient_id,
    MAX(encounter_date) as max_encounter_date
  FROM "Encounter"
  GROUP BY patient_id
)
SELECT
  e.patient_id,
  e.encounter_date, --potentially would have two entries if more than one encounter with identical date time stamp exist (unlikely edge case)
  e.status
FROM "Encounter" e
JOIN most_recent_encounters mre
  ON e.patient_id = mre.patient_id
  AND e.encounter_date = mre.max_encounter_date;

-- Question 5: Find patients who have had encounters with more than one practitioner
SELECT
	e.patient_id,
	COUNT(DISTINCT e.practitioner_id) as num_practitioners_seen
FROM "Encounter" e
GROUP BY e.patient_id
HAVING COUNT(DISTINCT e.practitioner_id)> 1

-- Question 6: Find the top 3 most prescribed medications
SELECT
	mr.medication_name,
	COUNT(*) AS num_prescriptions
FROM "MedicationRequest" mr
GROUP BY mr.medication_name
ORDER BY num_prescriptions DESC
LIMIT 3;

-- Note: Using LIMIT 3 assumes no ties. For tie handling, I'd use DENSE_RANK(). This wasn't necessary for this dataset from what I saw but is a more robust solution
WITH medication_counts AS (
  SELECT
    mr.medication_name,
    COUNT(*) AS num_prescriptions
  FROM "MedicationRequest" mr
  GROUP BY mr.medication_name
),
ranked_medications AS (
  SELECT
    medication_name,
    num_prescriptions,
    DENSE_RANK() OVER (ORDER BY num_prescriptions DESC) as rank
  FROM medication_counts
)
SELECT
  medication_name,
  num_prescriptions
FROM ranked_medications
WHERE rank <= 3
ORDER BY num_prescriptions DESC, medication_name;

-- Question 7: Get practitioners who have never prescribed any medication
SELECT
  p.id,
  p.name
FROM "Practitioner" p
LEFT JOIN "MedicationRequest" mr ON p.id = mr.practitioner_id
WHERE mr.practitioner_id IS NULL;

-- ============================================================================
-- ADVANCED QUESTIONS
-- ============================================================================

-- Question 8: Find the average number of encounters per patient, rounded to two decimal places
-- Clarifying question: Is this asking for average amount of visits across all patients?
-- or average amount of visits per patient taking into account Encounter.type
-- the response below is answering the first question
WITH encounter_counts AS (
  SELECT
    patient_id,
    COUNT(*) AS num_encounters
  FROM "Encounter"
  GROUP BY patient_id
)
SELECT
  ROUND(AVG(CAST(num_encounters AS NUMERIC)), 2) AS avg_encounters_per_patient
FROM encounter_counts;

-- the query above doesn't take into account patients with no encounters. If we want to include them, we can use the query below:
WITH all_patients AS (
  SELECT id FROM "Patient"
),
encounter_counts AS (
  SELECT
    p.id as patient_id,
    COUNT(e.id) AS num_encounters
  FROM all_patients p
  LEFT JOIN "Encounter" e ON p.id = e.patient_id
  GROUP BY p.id
)
SELECT
  ROUND(AVG(num_encounters), 2) AS avg_encounters_per_patient
FROM encounter_counts;

-- Question 9: Identify patients who have never had an encounter but have a medication request

SELECT
  mr.patient_id
FROM "MedicationRequest" mr
LEFT JOIN "Encounter" e ON mr.patient_id = e.patient_id
WHERE e.patient_id IS NULL;

-- Question 10: Determine patient retention by cohort
WITH first_encounters AS (
  SELECT
    patient_id,
    MIN(encounter_date) AS first_encounter_date
  FROM "Encounter"
  GROUP BY patient_id
),
follow_up_encounters AS (
  SELECT
    e.patient_id,
    e.encounter_date
  FROM "Encounter" e
  JOIN first_encounters fe ON e.patient_id = fe.patient_id
  WHERE e.encounter_date >= fe.first_encounter_date + INTERVAL '6 months'
)
SELECT
  DATE_TRUNC('month', first_encounter_date) AS cohort_month,
  COUNT(DISTINCT patient_id) AS num_patients
FROM first_encounters
WHERE patient_id IN (SELECT patient_id FROM follow_up_encounters)
GROUP BY cohort_month
ORDER BY cohort_month;
