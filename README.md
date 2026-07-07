# HR Employee Attrition Analysis

<img width="7360" height="4912" alt="scott-graham-5fNmWej4tAA-unsplash" src="https://github.com/user-attachments/assets/152ea44b-d6b0-4c19-9b55-a217d9c870c3" />


![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge&logo=mysql&logoColor=white)
![Power Bi](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)

## Overview
Exploratory analysis of an HR employee attrition dataset aimed at identifying the key factors driving employee turnover. By combining SQL for data exploration and Power BI for visualization, this project uncovers patterns across multiple aspects to help understand when and why employees are most likely to leave.

The dataset used in this project is the [IBM HR Analytics Employee Attrition & Performance](https://www.kaggle.com/datasets/saurabhbadole/hr-employee-attrition) synthetic dataset, available on Kaggle. It contains 1,470 rows and 35 columns, covering a wide range of employee attributes.

The main variables explored in this analysis include: Attrition, OverTime, Department, MonthlyIncome, Age, Gender, MaritalStatus, BusinessTravel, WorkLifeBalance, JobSatisfaction, EnvironmentSatisfaction, YearsAtCompany, and YearsSinceLastPromotion.

## Business Problem and Objectives
- Identify the **organizational, demographic, and behavioral factors** most strongly associated with employee attrition
- Identify the **highest-risk employee profile** and build a **scoring model** that enables proactive retention decisions

---
### Questions

1. What is the company's overall attrition rate, and how is it distributed across departments?
2. Which demographic profiles (age, gender, marital status) are most likely to leave?
3. Do employees who work overtime leave at significantly higher rates than those who don't?
4. Is there a relationship between the time without a promotion and the decision to leave the company?
5. How do satisfaction levels (with work, the environment, and work-life balance) compare between those who left and those who stayed?
6. Does the frequency of business travel influence the attrition rate?
7. Employees with shorter tenure are more likely to leave; is there a "critical retention period"?
8. How does monthly income influence attrition, and is there a meaningful salary gap between employees who left and those who stayed?


## Key Insights
- Among the **three departments**, **Sales** has the highest attrition rate at around **20.36%**, while **Research & Development** has the lowest, at **13.84%**, despite having more than twice the number of employees, suggesting greater burnout in the sales sector.
- Regarding **demographic aspects**, the employee profile most likely to leave the company is **single men between 18 and 25 years old**, which may suggest that the company struggles to retain younger employees due to working conditions and market opportunities.
- Regarding factors with significant impact, **working overtime** was the most critical one, approximately **30,53%** of employees who work overtime end up leaving the company.
- It was also found that **promotions** are not effectively contributing to employee retention. Employees promoted **less than 1 year ago** have an attrition rate of around **14.96%**, while those promoted **within the last 3 years** have the highest rate at **18.93%**. When the time since the last promotion exceeds 4 years, the rate gradually decreases, this could be due to employees reaching the ceiling of their positions.
- Regarding **satisfaction metrics** such as job satisfaction, environment satisfaction, and work-life balance, all had a significant impact on the attrition rate. Notably, **work-life balance** had the most dramatic effect, with approximately **31.25%** of employees who rated it at the minimum score having left the company.
- **Business travel** also proved to be a relevant satisfaction factor, employees who **travel frequently** for work have an attrition rate of around **24.91%**, which is 10% higher than those who travel rarely and three times higher than those who do not travel for work at all.
- Regarding **tenure**, the critical retention period is between **0 and 2 years**, with an attrition rate of **29.82%**, which drops drastically after this period and remains stable. This supports the earlier hypothesis that the company struggles to retain younger employees.
- The last aspect analyzed was **monthly income**. Employees earning **below 5k** represent the **highest-risk group**, with an attrition rate of **21.76%**. However, the data reveals a non-linear pattern, the rate drops to 9.44% among those earning between 5k and 7k, rises again to **15%** in the **7k–12k range**, and falls back to 8.70% for the highest earners above 12k. This inconsistency suggests that mid-range earners, likely experienced professionals, may be more exposed to competitive market offers, indicating the company faces retention challenges beyond compensation alone.

## Technologies Used
- **MySQL** — data exploration and attrition metrics calculation using
  CTEs, UNION ALL to consolidate multiple dimensions into a single result,
  conditional aggregation with CASE WHEN inside SUM(), inline bucketing
  of continuous variables inside GROUP BY, and data quality checks for
  NULLs, empty strings, and duplicates.

- **Power BI** — interactive dashboard with DAX measures for attrition
  KPIs using CALCULATE for context-modified aggregations, DIVIDE for
  safe attrition rate calculations, and dynamic filtering across
  demographic, work, and satisfaction dimensions, calculated columns with SWITCH for composite risk scoring and custom sort ordering across employee risk categories.

## SQL Sample
Analyzing the demographics metrics (Age, Gender and Marital Status )

```sql
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
```

For the full analysis, see [`HR-Attrition-Analysis.sql`](queries/HR-Attrition-Analysis.sql)

## Project Structure
```
hr-attrition-analysis/
│
├── assets/                  - Dashboard screenshots
├── queries/                 - SQL scripts used for exploration
│   └── attrition_analysis.sql
├── HR-Employee-Attrition.csv
├── dashboard.pbix
└── README.md
```

## How to Use
1. Clone this repository
2. Import `HR-Employee-Attrition.csv` into MySQL using the Table Data Import Wizard and run the queries inside the `queries/` folder
3. Open `dashboard.pbix` in Power BI Desktop and update the data source connection if needed

## Dashboard

The report is structured across four pages, each addressing a specific
analytical axis of the attrition problem.

The **Overview** page presents the high-level KPIs: total employees,
total attrition, average age, and overall attrition rate alongside
attrition breakdowns by department, job role, and education level.
Dropdown Slicers for Department, Job Level, and Education Field allow cross-filtering
across all visuals on this page.

The **Demographics** page explores how gender, age group, marital status,
and business travel frequency relate to attrition. It includes Job Level
and OverTime slicers, enabling the user to isolate specific employee
profiles and observe how demographic patterns shift.

The **Work Factors** page focuses on overtime, years at the company,
time since last promotion, and monthly income. Slicers for Department,
Job Level, and Job Role allow users to drill into specific contexts. For example, isolating Sales Representatives to validate the highest-risk
profile identified in the analysis.

The **Satisfaction Metrics** page covers all four satisfaction dimensions:
job satisfaction, environment satisfaction, work-life balance, and
relationship satisfaction. Department and Job Level slicers are available,
and the page uses area charts to make the score-to-attrition gradient
immediately readable.

The **Risk Profile** page consolidates the findings of the analysis into an actionable risk scoring model. Each employee receives a composite Risk Score based on the most critical attrition factors identified: overtime work (25pts), age between 18–25 (20pts), tenure under 2 years (20pts), monthly income below $5k (15pts), minimum work-life balance score (10pts), and frequent business travel (10pts). The weights reflect the attrition rates calculated in the MySQL analysis.

Employees are then classified into four categories based on their total score: Critical, High, Medium, and Low. The page includes a distribution chart by category, a score frequency chart, and a filtered table listing only High and Critical employees with their department, job role, and individual score. Department, Job Level, Gender, and Income Group slicers allow managers to isolate their own team and identify which employees require immediate attention.

Navigation between pages is handled via arrow buttons in the bottom
corners of each page.

## Dashboard Preview

### Overview

<img width="1165" height="655" alt="Screenshot (98)" src="https://github.com/user-attachments/assets/e89d7768-34ba-4593-b217-45711248316d" />

------------------

### Demographics Analysis

<img width="1160" height="655" alt="Screenshot (102)" src="https://github.com/user-attachments/assets/ed0ee9ab-c3d0-4db6-a546-b0874b4f26a7" />


------------------

### Work Factors Analysis

<img width="1160" height="650" alt="Screenshot (100)" src="https://github.com/user-attachments/assets/ad0441f3-3a66-4e2e-8304-af42a74e4d8a" />


------------------

### Satisfaction Metrics

<img width="1161" height="661" alt="Screenshot (109)" src="https://github.com/user-attachments/assets/5c31c09b-45f1-4de3-86eb-a3f10fdaa14f" />


------------------

### Risk Profile

<img width="1160" height="662" alt="Risk Profile" src="https://github.com/user-attachments/assets/91c65e66-b915-424e-a98e-4d36b16cfc39" />


------------------

## Conclusions

The **highest-risk profile** identified is a single male, aged 18–25, working as a Sales
Representative, earning below $5k, and working overtime. Retention efforts targeting this
specific group are likely to yield the greatest impact.


Based on the findings of this analysis, four main recommendations stand out:

1. The most urgent action is **overtime management**. With a turnover rate nearly three times higher
among employees who work overtime, the company should investigate which teams and roles are
most affected and redistribute workload accordingly. No retention strategy is more effective
than preventing burnout in the first place.
2. On **compensation**, the priority should not be across-the-board raises, but targeted reviews for
**mid-range earners in the $7k–$12k bracket**, likely experienced professionals, who are the most
exposed to external market offers and the hardest to replace.
3. The **Sales department** warrants a dedicated retention plan, given its disproportionately
high attrition rate. This could include clearer career progression paths, revised target
structures, or more frequent performance conversations to keep employees engaged before they
decide to leave.
4. Invest in **satisfaction monitoring**. Employees with the lowest work-life balance scores
showed an attrition rate of 31.25%, and those with the lowest job satisfaction and environment
satisfaction scores followed a similar pattern. These metrics should be treated as **early warning
signals**, regular surveys and manager check-ins could help identify at-risk employees
before they decide to leave.

However, it's also important to point that this analysis has the limitation of the use of an synthetic dataset, which may not fully reflect the complexity and noise present in real-world HR data. 
