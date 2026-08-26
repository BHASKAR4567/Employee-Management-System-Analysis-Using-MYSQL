CREATE DATABASE IF NOT EXISTS project;
USE project;
-- 1. JOB DEPARTMENT
CREATE TABLE JobDepartment (
    Job_ID INT PRIMARY KEY,
    jobdept VARCHAR(50),
    name VARCHAR(100),
    description TEXT,
    salaryrange VARCHAR(50),
    role_level VARCHAR(20)
);
-- 2. SALARY / BONUS
CREATE TABLE SalaryBonus (
    salary_ID INT PRIMARY KEY,
    Job_ID INT,
    amount DECIMAL(10,2),
    annual DECIMAL(10,2),
    bonus DECIMAL(10,2),
    bonus_pct DECIMAL(5,2),
    CONSTRAINT fk_salary_job
        FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- 3. EMPLOYEE
CREATE TABLE Employee (
    emp_ID INT PRIMARY KEY,
    firstname VARCHAR(50),
    lastname VARCHAR(50),
    gender VARCHAR(10),
    age INT,
    contact_add VARCHAR(100),
    emp_email VARCHAR(100) UNIQUE,
    emp_pass VARCHAR(50),
    Job_ID INT,
    hire_date DATE,
    tenure_years DECIMAL(4,1),
    CONSTRAINT fk_employee_job
        FOREIGN KEY (Job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);
-- 4. QUALIFICATION
CREATE TABLE Qualification (
    QualID INT PRIMARY KEY,
    Emp_ID INT,
    Position VARCHAR(50),
    Requirements VARCHAR(255),
    Date_In DATE,
    degree_level VARCHAR(30),
    CONSTRAINT fk_qualification_emp
        FOREIGN KEY (Emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- 5. LEAVES
CREATE TABLE Leaves (
    leave_ID INT PRIMARY KEY,
    emp_ID INT,
    date DATE,
    reason TEXT,
    leave_days INT,
    CONSTRAINT fk_leave_emp
        FOREIGN KEY (emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
-- 6. PAYROLL
CREATE TABLE Payroll (
    payroll_ID INT PRIMARY KEY,
    emp_ID INT,
    job_ID INT,
    salary_ID INT,
    date DATE,
    report TEXT,
    total_amount DECIMAL(10,2),
    raise_applied CHAR(1),

    CONSTRAINT fk_payroll_emp
        FOREIGN KEY (emp_ID)
        REFERENCES Employee(emp_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_job
        FOREIGN KEY (job_ID)
        REFERENCES JobDepartment(Job_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,

    CONSTRAINT fk_payroll_salary
        FOREIGN KEY (salary_ID)
        REFERENCES SalaryBonus(salary_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);
USE project;

CREATE OR REPLACE VIEW EmployeeProfile AS
SELECT 
    e.emp_ID,
    e.firstname,
    e.lastname,
    e.tenure_years,
    jd.jobdept,
    jd.role_level,
    q.degree_level,
    sb.amount AS monthly_salary,
    sb.bonus_pct
FROM Employee e
JOIN JobDepartment jd 
    ON e.Job_ID = jd.Job_ID
LEFT JOIN Qualification q 
    ON e.emp_ID = q.Emp_ID
LEFT JOIN SalaryBonus sb 
    ON e.Job_ID = sb.Job_ID;
-- CHECK DATA

SELECT COUNT(*) AS JobDepartment_Rows FROM JobDepartment;
SELECT COUNT(*) AS SalaryBonus_Rows FROM SalaryBonus;
SELECT COUNT(*) AS Employee_Rows FROM Employee;
SELECT COUNT(*) AS Qualification_Rows FROM Qualification;
SELECT COUNT(*) AS Leaves_Rows FROM Leaves;
SELECT COUNT(*) AS Payroll_Rows FROM Payroll;
-- 1. Career Stagnation
SELECT *FROM EmployeeProfile WHERE tenure_years >= 5 AND role_level IN ('Junior', 'Mid');
-- 2. Salary Below Department Average
SELECT 
    emp_ID,
    firstname,
    lastname,
    jobdept,
    monthly_salary
FROM EmployeeProfile ep
WHERE monthly_salary < (
    SELECT AVG(monthly_salary)
    FROM EmployeeProfile
    WHERE jobdept = ep.jobdept
);

-- 3. Department Salary Gap
SELECT 
    jobdept,
    MIN(monthly_salary) AS min_salary,
    MAX(monthly_salary) AS max_salary,
    MAX(monthly_salary) - MIN(monthly_salary) AS salary_gap
FROM EmployeeProfile
GROUP BY jobdept
ORDER BY salary_gap DESC;

-- 4. Qualification-Role Mismatch
SELECT 
    emp_ID,
    firstname,
    lastname,
    role_level,
    degree_level
FROM EmployeeProfile
WHERE (degree_level = 'Master''s' 
       AND role_level IN ('Junior', 'Mid'))
   OR (degree_level = 'Certification/Other' 
       AND role_level IN ('Senior', 'Executive'));

-- 5. Leave Analysis
SELECT 
    emp_ID,
    COUNT(*) AS total_leaves,
    SUM(leave_days) AS total_leave_days
FROM Leaves
GROUP BY emp_ID
ORDER BY total_leave_days DESC;

-- 6. Workforce Risk Score
SELECT 
    ep.emp_ID,
    ep.firstname,
    ep.lastname,
    ep.jobdept,
    ep.role_level,
    (
        CASE 
            WHEN ep.tenure_years >= 5 
                 AND ep.role_level IN ('Junior', 'Mid')
            THEN 1 ELSE 0 
        END
        +
        CASE 
            WHEN ep.monthly_salary < da.avg_sal
            THEN 1 ELSE 0 
        END
        +
        CASE 
            WHEN nr.emp_ID IS NOT NULL
            THEN 1 ELSE 0 
        END
    ) AS risk_score
FROM EmployeeProfile ep

JOIN (
    SELECT 
        jobdept,
        AVG(monthly_salary) AS avg_sal
    FROM EmployeeProfile
    GROUP BY jobdept
) da ON ep.jobdept = da.jobdept

LEFT JOIN (
    SELECT emp_ID
    FROM Payroll
    GROUP BY emp_ID
    HAVING SUM(
        CASE WHEN raise_applied = 'Y' THEN 1 ELSE 0 END
    ) = 0
) nr ON ep.emp_ID = nr.emp_ID

ORDER BY risk_score DESC;