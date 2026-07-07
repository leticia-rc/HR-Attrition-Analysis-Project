 SELECT * FROM employees
LIMIT 10;

-- Verifying duplicates
SELECT EmployeeNumber, COUNT(*) AS duplicates
FROM employees
GROUP BY EmployeeNumber
HAVING COUNT(*) > 1;

-- Verifying null values
SELECT
    SUM(CASE WHEN Age IS NULL THEN 1 ELSE 0 END) AS Age_nulls,
    SUM(CASE WHEN Attrition IS NULL THEN 1 ELSE 0 END) AS Attrition_nulls,
    SUM(CASE WHEN BusinessTravel IS NULL THEN 1 ELSE 0 END) AS BusinessTravel_nulls,
    SUM(CASE WHEN DailyRate IS NULL THEN 1 ELSE 0 END) AS DailyRate_nulls,
    SUM(CASE WHEN Department IS NULL THEN 1 ELSE 0 END) AS Department_nulls,
    SUM(CASE WHEN DistanceFromHome IS NULL THEN 1 ELSE 0 END) AS DistanceFromHome_nulls,
    SUM(CASE WHEN Education IS NULL THEN 1 ELSE 0 END) AS Education_nulls,
    SUM(CASE WHEN EducationField IS NULL THEN 1 ELSE 0 END) AS EducationField_nulls,
    SUM(CASE WHEN EnvironmentSatisfaction IS NULL THEN 1 ELSE 0 END) AS EnvironmentSatisfaction_nulls,
    SUM(CASE WHEN Gender IS NULL THEN 1 ELSE 0 END) AS Gender_nulls,
    SUM(CASE WHEN HourlyRate IS NULL THEN 1 ELSE 0 END) AS HourlyRate_nulls,
    SUM(CASE WHEN JobInvolvement IS NULL THEN 1 ELSE 0 END) AS JobInvolvement_nulls,
    SUM(CASE WHEN JobLevel IS NULL THEN 1 ELSE 0 END) AS JobLevel_nulls,
    SUM(CASE WHEN JobRole IS NULL THEN 1 ELSE 0 END) AS JobRole_nulls,
    SUM(CASE WHEN JobSatisfaction IS NULL THEN 1 ELSE 0 END) AS JobSatisfaction_nulls,
    SUM(CASE WHEN MaritalStatus IS NULL THEN 1 ELSE 0 END) AS MaritalStatus_nulls,
    SUM(CASE WHEN MonthlyIncome IS NULL THEN 1 ELSE 0 END) AS MonthlyIncome_nulls,
    SUM(CASE WHEN MonthlyRate IS NULL THEN 1 ELSE 0 END) AS MonthlyRate_nulls,
    SUM(CASE WHEN NumCompaniesWorked IS NULL THEN 1 ELSE 0 END) AS NumCompaniesWorked_nulls,
    SUM(CASE WHEN OverTime IS NULL THEN 1 ELSE 0 END) AS OverTime_nulos,
    SUM(CASE WHEN PercentSalaryHike IS NULL THEN 1 ELSE 0 END) AS PercentSalaryHike_nulls,
    SUM(CASE WHEN PerformanceRating IS NULL THEN 1 ELSE 0 END) AS PerformanceRating_nulls,
    SUM(CASE WHEN RelationshipSatisfaction IS NULL THEN 1 ELSE 0 END) AS RelationshipSatisfaction_nulls,
    SUM(CASE WHEN StockOptionLevel IS NULL THEN 1 ELSE 0 END) AS StockOptionLevel_nulls,
    SUM(CASE WHEN TotalWorkingYears IS NULL THEN 1 ELSE 0 END) AS TotalWorkingYears_nulls,
    SUM(CASE WHEN TrainingTimesLastYear IS NULL THEN 1 ELSE 0 END) AS TrainingTimesLastYear_nulls,
    SUM(CASE WHEN WorkLifeBalance IS NULL THEN 1 ELSE 0 END) AS WorkLifeBalance_nulls,
    SUM(CASE WHEN YearsAtCompany IS NULL THEN 1 ELSE 0 END) AS YearsAtCompany_nulls,
    SUM(CASE WHEN YearsInCurrentRole IS NULL THEN 1 ELSE 0 END) AS YearsInCurrentRole_nulls,
    SUM(CASE WHEN YearsSinceLastPromotion IS NULL THEN 1 ELSE 0 END) AS YearsSinceLastPromotion_nulls,
    SUM(CASE WHEN YearsWithCurrManager IS NULL THEN 1 ELSE 0 END) AS YearsWithCurrManager_nulls
FROM employees;

-- Verifying missing values
SELECT
    SUM(CASE WHEN Attrition = '' THEN 1 ELSE 0 END) AS Attrition_empty,
    SUM(CASE WHEN BusinessTravel = '' THEN 1 ELSE 0 END) AS BusinessTravel_empty,
    SUM(CASE WHEN Department = '' THEN 1 ELSE 0 END) AS Department_empty,
    SUM(CASE WHEN EducationField = '' THEN 1 ELSE 0 END) AS EducationField_empty,
    SUM(CASE WHEN Gender = '' THEN 1 ELSE 0 END) AS Gender_empty,
    SUM(CASE WHEN JobRole = '' THEN 1 ELSE 0 END) AS JobRole_empty,
    SUM(CASE WHEN MaritalStatus = '' THEN 1 ELSE 0 END) AS MaritalStatus_empty,
    SUM(CASE WHEN OverTime = '' THEN 1 ELSE 0 END) AS OverTime_empty
FROM employees;

#There aren't any duplicates, nulls or missing values

-- Company overview
SELECT 
    COUNT(*) AS total_employees,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay,
    CAST((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS DECIMAL(5,2)) AS attrition_rate
FROM employees;

-- 1. What is the company's overall attrition rate, and how is it distributed across departments?
SELECT 
    Department, 
    employees_left,
    employees_stay, 
    CAST((employees_left * 100.0) / (employees_left + employees_stay) AS DECIMAL(5,2)) AS attrition_rate
FROM (
    SELECT 
        Department, 
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
        SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay
    FROM employees
    GROUP BY Department
) AS dept_summary
ORDER BY Department DESC;

-- 2. Which demographic profiles (age, gender, marital status) are most likely to leave?

SELECT Age, COUNT(*) as total
FROM employees
GROUP BY Age
ORDER BY Age;


WITH base AS (
    SELECT 
        Age,
        Gender,
        MaritalStatus,
        CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS employees_left,
        CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END AS employees_stay
    FROM employees
)

SELECT 
    demographic,
    category,
    employees_left,
    employees_stay,
    CAST((employees_left * 100.0) / (employees_left + employees_stay) AS DECIMAL(5,2)) AS attrition_rate
FROM (
    (SELECT 
        'Age Group' AS demographic,
        CASE
            WHEN Age BETWEEN 18 AND 25 THEN 'Early Career'
            WHEN Age BETWEEN 26 AND 35 THEN 'Peak Career'
            WHEN Age BETWEEN 36 AND 45 THEN 'Mid Career'
            ELSE 'Senior'
        END AS category,
        SUM(employees_left) AS employees_left,
        SUM(employees_stay) AS employees_stay
    FROM base
    GROUP BY category)

    UNION ALL

    (SELECT 'Gender', Gender, SUM(employees_left), SUM(employees_stay)
    FROM base
    GROUP BY Gender)

    UNION ALL

    (SELECT 'Marital Status', MaritalStatus, SUM(employees_left), SUM(employees_stay)
    FROM base
    GROUP BY MaritalStatus)

) AS demographic_summary
ORDER BY demographic, attrition_rate DESC;


-- 3. Do employees who work overtime leave at significantly higher rates than those who don't?
SELECT Overtime,
    employees_left, 
    employees_stay,
    CAST((employees_left * 100.0) / (employees_left + employees_stay) AS DECIMAL(5,2)) AS attrition_rate
FROM (
    SELECT Overtime,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
        SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay
    FROM employees
    GROUP BY Overtime
) AS overtime_summary
ORDER BY Overtime DESC;

-- 4. Is there a relationship between the time without a promotion and the decision to leave the company?
SELECT YearsSinceLastPromotion, COUNT(*) as total
FROM employees
GROUP BY YearsSinceLastPromotion
ORDER BY YearsSinceLastPromotion;

SELECT promotion_groups,
    employees_left, 
    employees_stay,
    CAST((employees_left * 100.0) / (employees_left + employees_stay) AS DECIMAL(5,2)) AS attrition_rate
FROM (
    SELECT 
		CASE 
        WHEN YearsSinceLastPromotion = 0 THEN 'Recent'
        WHEN YearsSinceLastPromotion BETWEEN 1 AND 3 THEN 'Short Gap'
		WHEN YearsSinceLastPromotion BETWEEN 4 AND 7 THEN 'Medium Gap'
        ELSE 'Huge Gap' end as promotion_groups,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
        SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay
    FROM employees
    GROUP BY promotion_groups
) AS promotion_summary
ORDER BY promotion_groups DESC;

--  Promotion x Job Satisfaction
WITH promotion_base AS (
    SELECT 
        CASE 
            WHEN YearsSinceLastPromotion = 0 THEN 'Recent'
            WHEN YearsSinceLastPromotion BETWEEN 1 AND 3 THEN 'Short Gap'
            WHEN YearsSinceLastPromotion BETWEEN 4 AND 7 THEN 'Medium Gap'
            ELSE 'Huge Gap' 
        END AS promotion_groups,
        MonthlyIncome,
        JobSatisfaction,
        JobLevel,
        YearsAtCompany,
        CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS employees_left,
        CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END AS employees_stay
    FROM employees
)

SELECT 
    promotion_groups,
    CAST(AVG(MonthlyIncome)    AS DECIMAL(10,2)) AS avg_monthly_income,
    CAST(AVG(JobSatisfaction)  AS DECIMAL(3,2))  AS avg_job_satisfaction,
    CAST(AVG(JobLevel)         AS DECIMAL(10,2)) AS avg_job_level,
    CAST(AVG(YearsAtCompany)   AS DECIMAL(3,2))  AS avg_year_at_company,
    SUM(employees_left)  AS employees_left,
    SUM(employees_stay)  AS employees_stay,
    CAST((SUM(employees_left) * 100.0) / (SUM(employees_left) + SUM(employees_stay)) AS DECIMAL(5,2)) AS attrition_rate
FROM promotion_base
GROUP BY promotion_groups
ORDER BY attrition_rate DESC;

-- 5. How do satisfaction levels (with work, the environment, and work-life balance) compare between those who left and those who stayed?
WITH base AS (
    SELECT 
        JobSatisfaction,
        EnvironmentSatisfaction,
        WorkLifeBalance,
        CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END AS employees_left,
        CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END AS employees_stay
    FROM employees
)

SELECT 
    metric,
    score,
    employees_left,
    employees_stay,
    CAST((employees_left * 100.0) / (employees_left + employees_stay) AS DECIMAL(5,2)) AS attrition_rate
FROM (
    SELECT 'Job Satisfaction' AS metric, JobSatisfaction AS score,
        SUM(employees_left) AS employees_left, SUM(employees_stay) AS employees_stay
    FROM base
    GROUP BY JobSatisfaction

    UNION ALL

    SELECT 'Environment Satisfaction', EnvironmentSatisfaction,
        SUM(employees_left), SUM(employees_stay)
    FROM base
    GROUP BY EnvironmentSatisfaction

    UNION ALL

    SELECT 'Work Life Balance', WorkLifeBalance,
        SUM(employees_left), SUM(employees_stay)
    FROM base
    GROUP BY WorkLifeBalance

) AS satisfaction_summary
ORDER BY metric, score;

-- 6. Does the frequency of business travel influence the attrition rate?
SELECT BusinessTravel,
    employees_left, 
    employees_stay,
    CAST((employees_left * 100.0) / (employees_left + employees_stay) AS DECIMAL(5,2)) AS attrition_rate
FROM (
    SELECT BusinessTravel,
        SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
        SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay
    FROM employees
    GROUP BY BusinessTravel
) AS business_travel_summary
ORDER BY BusinessTravel DESC;

-- 7. Employees with shorter tenure are more likely to leave; is there a "critical retention period"?
SELECT 
    CASE 
        WHEN YearsAtCompany BETWEEN 0 AND 2 THEN 'First 2 years'
        WHEN YearsAtCompany BETWEEN 3 AND 5 THEN 'Between 3-5 years'
        WHEN YearsAtCompany BETWEEN 6 AND 10 THEN 'Between 6-10 years'
        ELSE '10+ years'
    END AS tenure_group,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay,
    CAST((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS DECIMAL(5,2)) AS attrition_rate
FROM employees
GROUP BY tenure_group
ORDER BY attrition_rate DESC;

-- 8. How does monthly income influence attrition, and is there a meaningful salary gap between employees who left and those who stayed?
SELECT 
    CASE 
        WHEN MonthlyIncome <= 5000 THEN 'up to 5k'
        WHEN MonthlyIncome BETWEEN 5001 AND 7000 THEN '5k - 7k'
        WHEN MonthlyIncome BETWEEN 7001 AND 12000 THEN '7k - 12k'
        WHEN MonthlyIncome BETWEEN 12001 AND 16000 THEN '12k - 16k'
        ELSE '16k+'
    END AS income_group,
    SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) AS employees_left,
    SUM(CASE WHEN Attrition = 'No'  THEN 1 ELSE 0 END) AS employees_stay,
    CAST((SUM(CASE WHEN Attrition = 'Yes' THEN 1 ELSE 0 END) * 100.0) / COUNT(*) AS DECIMAL(5,2)) AS attrition_rate,
    SUM(EmployeeCount) as total_employees
FROM employees
GROUP BY income_group
ORDER BY attrition_rate DESC;

SELECT 
    Attrition,
    ROUND(AVG(MonthlyIncome), 2) AS Avg_Monthly_Income,
    COUNT(*) AS Total_Employees
FROM employees
GROUP BY Attrition;