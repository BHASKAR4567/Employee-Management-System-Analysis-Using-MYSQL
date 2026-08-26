## 📌 Project Overview

**Employee Mamagement system ** is a SQL-based HR analytics project that analyzes employee data to identify workforce-related issues and generate meaningful insights for HR decision-making.

The project analyzes **employee experience, salary, qualifications, job roles, leave patterns, and salary raises** to identify career stagnation, salary disparities, qualification–role mismatches, and workforce risks.

## 🎯 Objectives

* Analyze employee experience, salary, qualifications, and job roles.
* Identify employees experiencing career stagnation.
* Identify employees earning below their department's average salary.
* Analyze salary disparities across departments.
* Detect qualification–role mismatches.
* Analyze employee leave patterns.
* Develop a **Workforce Risk Score** to identify employees who may require HR attention.

## 🗂️ Database Structure

The project uses a relational database consisting of the following tables:

| Table         | Description                                  |
| ------------- | -------------------------------------------- |
| Employee      | Stores employee information                  |
| Department    | Stores department information                |
| Salary        | Stores employee salary and raise information |
| Leave         | Stores employee leave records                |
| Qualification | Stores employee qualification details        |
| Payroll       | Stores employee payroll information          |

The **Employee** table acts as the central entity and is connected to the other tables using foreign keys.

## 🔍 Key Analysis Questions

The project answers important HR-related questions such as:

1. Which employees have been with the organization for **5 or more years** but are still in Junior or Mid-level roles?
2. Which employees are earning a monthly salary below the average salary of their department?
3. Which departments have the largest salary gap between the lowest-paid and highest-paid employees?
4. Which employees have a mismatch between their educational qualification and current role level?
5. Which employees have taken the highest number of leaves and total leave days?
6. Which employees have the highest **Workforce Risk Score**?

## 🛠️ SQL Concepts Used

* SELECT
* WHERE
* JOINs
* GROUP BY
* ORDER BY
* Aggregate Functions
* CASE Statements
* Subqueries
* Correlated Subqueries
* Primary Keys
* Foreign Keys
* Relational Database Concepts
* Salary Analysis
* Risk Score Calculation

## 📊 Key Insights

The analysis helped identify:

* Employees facing career stagnation despite having higher experience.
* Salary disparities among employees and across departments.
* Qualification–role mismatches.
* Employees earning below their department's average salary.
* Employees with unusually high leave usage.
* Employees with higher workforce risk scores.

## 💼 Business Value

This project demonstrates how SQL can be used to support **data-driven HR decision-making**.

The insights can help management better understand:

* Employee career growth
* Salary fairness
* Employee placement
* Qualification and role alignment
* Leave patterns
* Workforce risks

The analysis can support more **fair, transparent, and data-driven decisions** related to salary, promotions, employee roles, and workforce management.

## 📁 Project Files

```text
Employee-Workforce-Analysis-SQL/
│
├── README.md
├── pro.sql
├── ER_Diagram.png
└── Employee_Workforce_Analysis_Presentation.pptx
```

## 🧠 What I Learned

* Designed and managed a relational database using SQL.
* Improved SQL skills using JOINs, subqueries, GROUP BY, CASE, and aggregate functions.
* Analyzed career stagnation, salary disparities, qualification mismatches, and leave patterns.
* Worked with multiple related tables.
* Debugged and developed complex SQL queries.
* Created a Workforce Risk Score for HR analysis.

## 👨‍💻 Author

**G. Bhaskar**
B.Tech – Computer Science Engineering

### ⭐ If you find this project useful, consider giving the repository a star!
