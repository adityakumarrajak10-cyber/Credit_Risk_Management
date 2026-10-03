
SELECT COUNT(*)
FROM credit_risk_dataset;

SELECT *
FROM credit_risk_dataset
LIMIT 5;

SELECT
    person_age,
    person_income,
    person_home_ownership,
    person_emp_length,
    loan_intent,
    loan_grade,
    loan_amnt,
    loan_int_rate,
    loan_status,
    loan_percent_income,
    cb_person_default_on_file,
    cb_person_cred_hist_length,
    COUNT(*) AS duplicate_count
FROM credit_risk_dataset
GROUP BY
    person_age,
    person_income,
    person_home_ownership,
    person_emp_length,
    loan_intent,
    loan_grade,
    loan_amnt,
    loan_int_rate,
    loan_status,
    loan_percent_income,
    cb_person_default_on_file,
    cb_person_cred_hist_length
HAVING COUNT(*) > 1;

SELECT
    SUM(person_age IS NULL) AS missing_age,
    SUM(person_income IS NULL) AS missing_income,
    SUM(person_home_ownership IS NULL) AS missing_home_ownership,
    SUM(person_emp_length IS NULL) AS missing_emp_length,
    SUM(loan_intent IS NULL) AS missing_loan_intent,
    SUM(loan_grade IS NULL) AS missing_loan_grade,
    SUM(loan_amnt IS NULL) AS missing_loan_amount,
    SUM(loan_int_rate IS NULL) AS missing_interest_rate,
    SUM(loan_status IS NULL) AS missing_loan_status,
    SUM(loan_percent_income IS NULL) AS missing_loan_percent_income,
    SUM(cb_person_default_on_file IS NULL) AS missing_previous_default,
    SUM(cb_person_cred_hist_length IS NULL) AS missing_credit_history
FROM credit_risk_dataset;

SELECT
    SUM(duplicate_count - 1) AS extra_duplicate_rows
FROM (
    SELECT
        person_age,
        person_income,
        person_home_ownership,
        person_emp_length,
        loan_intent,
        loan_grade,
        loan_amnt,
        loan_int_rate,
        loan_status,
        loan_percent_income,
        cb_person_default_on_file,
        cb_person_cred_hist_length,
        COUNT(*) AS duplicate_count
    FROM credit_risk_dataset
    GROUP BY
        person_age,
        person_income,
        person_home_ownership,
        person_emp_length,
        loan_intent,
        loan_grade,
        loan_amnt,
        loan_int_rate,
        loan_status,
        loan_percent_income,
        cb_person_default_on_file,
        cb_person_cred_hist_length
    HAVING COUNT(*) > 1
) AS duplicates;

CREATE TABLE credit_risk_clean AS
SELECT DISTINCT *
FROM credit_risk_dataset;

SELECT COUNT(*)
FROM credit_risk_clean;

SELECT
    loan_status,
    COUNT(*) AS total_loans
FROM credit_risk_clean
GROUP BY loan_status;

SELECT
    loan_grade,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans
FROM credit_risk_clean
GROUP BY loan_grade
ORDER BY loan_grade;

SELECT
    loan_grade,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY loan_grade
ORDER BY loan_grade;
use credit_risk_analysis;
SELECT
    cb_person_default_on_file,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY cb_person_default_on_file;

SELECT
    loan_intent,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY loan_intent
ORDER BY loan_intent;

SELECT
    CASE
        WHEN loan_amnt < 10000 THEN 'Small'
        WHEN loan_amnt < 25000 THEN 'Medium'
        ELSE 'Large'
    END AS loan_size,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY loan_size
ORDER BY loan_size;

SELECT
    MIN(loan_amnt) AS minimum_loan,
    MAX(loan_amnt) AS maximum_loan
FROM credit_risk_clean;

SELECT loan_amnt
FROM credit_risk_clean
LIMIT 10;

DESCRIBE credit_risk_clean;

SELECT loan_amnt
FROM credit_risk_clean
WHERE loan_amnt NOT REGEXP '^[0-9]+$'
LIMIT 10;

ALTER TABLE credit_risk_clean
ADD COLUMN loan_amnt_num INT;

UPDATE credit_risk_clean
SET loan_amnt_num = CAST(REPLACE(loan_amnt, ',', '') AS UNSIGNED)
WHERE loan_amnt_num IS NULL;

SET SQL_SAFE_UPDATES = 0;

UPDATE credit_risk_clean
SET loan_amnt_num = CAST(REPLACE(loan_amnt, ',', '') AS UNSIGNED)
WHERE loan_amnt_num IS NULL;

SELECT loan_amnt_num
FROM credit_risk_clean
LIMIT 10;
SET SQL_SAFE_UPDATES = 1;

SELECT
    MIN(loan_amnt_num) AS minimum_loan,
    MAX(loan_amnt_num) AS maximum_loan
FROM credit_risk_clean;

SELECT
    CASE
        WHEN loan_amnt_num <= 10000 THEN 'Small'
        WHEN loan_amnt_num <= 25000 THEN 'Medium'
        ELSE 'Large'
    END AS loan_size,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY loan_size
ORDER BY loan_size;

SELECT
    CASE
        WHEN loan_percent_income <= 0.20 THEN 'Low Burden'
        WHEN loan_percent_income <= 0.40 THEN 'Medium Burden'
        ELSE 'High Burden'
    END AS income_burden,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY income_burden
ORDER BY income_burden;

SELECT
    CASE
        WHEN person_emp_length < 2 THEN 'Less than 2 years'
        WHEN person_emp_length <= 5 THEN '2–5 years'
        ELSE 'More than 5 years'
    END AS employment_group,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY employment_group
ORDER BY employment_group;

SELECT
    person_home_ownership,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY person_home_ownership
ORDER BY person_home_ownership;

SELECT
    CASE
        WHEN loan_int_rate < 10 THEN 'Below 10%'
        WHEN loan_int_rate < 15 THEN '10%–15%'
        ELSE '15% or higher'
    END AS interest_rate_group,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY interest_rate_group
ORDER BY interest_rate_group;

SET SQL_SAFE_UPDATES = 0;

ALTER TABLE credit_risk_clean
ADD COLUMN person_income_num INT;

UPDATE credit_risk_clean
SET person_income_num = CAST(REPLACE(person_income, ',', '') AS UNSIGNED);

SELECT
    person_income,
    person_income_num
FROM credit_risk_clean
LIMIT 10;

SET SQL_SAFE_UPDATES = 1;

SELECT
    CASE
        WHEN person_income_num < 30000 THEN 'Below 30K'
        WHEN person_income_num < 60000 THEN '30K–60K'
        ELSE '60K or higher'
    END AS income_group,
    COUNT(*) AS total_loans,
    SUM(loan_status = 1) AS defaulted_loans,
    ROUND(SUM(loan_status = 1) * 100.0 / COUNT(*), 2) AS default_rate
FROM credit_risk_clean
GROUP BY income_group
ORDER BY income_group;

SELECT *
FROM credit_risk_clean;



















