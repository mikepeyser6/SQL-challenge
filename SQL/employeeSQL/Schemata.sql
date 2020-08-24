-- Data Engineering --
-- Drop Tables if Existing
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS dept_emp;
DROP TABLE IF EXISTS dept_manager;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS salaries;
DROP TABLE IF EXISTS titles;


-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/ primary_keys and foriegn_keys
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/FJQ5dR
--import csv file into corresponding sql table

CREATE TABLE "departments" (
    "dept_no" VARCHAR   NOT NULL,
    "dept_name" VARCHAR   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "dept_emp" (
    "emp_no" INT   NOT NULL,
    "dept_no" VARCHAR   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR   NOT NULL,
    "emp_no" INT   NOT NULL
);

CREATE TABLE "employees" (
    "emp_no" INT   NOT NULL,
    "emp_title_id" VARCHAR   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR   NOT NULL,
    "last_name" VARCHAR   NOT NULL,
    "gender" VARCHAR   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" INT   NOT NULL,
    "salary" INT   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" VARCHAR   NOT NULL,
    "title" VARCHAR   NOT NULL
);

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

-- Query * FROM Each Table Confirming Data in the table(impoted csv file)
SELECT * FROM departments;
SELECT * FROM dept_emp;
SELECT * FROM dept_manager;
SELECT * FROM employees;
SELECT * FROM salaries;
SELECT * FROM titles;

-- List the following details of each employee: employee number, last name, first name, sex, and salary.

select employees.emp_no as "employee number", employees.last_name as "last name", employees.first_name as "first name", employees.gender, salaries.salary
from employees
inner join salaries on
employees.emp_no=salaries.emp_no;

-- List first name, last name, and hire date for employees who were hired in 1986.

select first_name, last_name, hire_date
from employees where hire_date between '01/01/1986' and '12/31/1986';

-- List the manager of each department with the following information: department number, department name, the manager's employee number, last name, first name.

select departments.dept_no as "department number", departments.dept_name as "department name",
dept_manager.emp_no as "employee number", employees.last_name as "last name", employees.first_name as "first name"
from departments
inner join dept_manager on 
departments.dept_no= dept_manager.dept_no
inner join employees on 
dept_manager.emp_no= employees.emp_no;

-- List the department of each employee with the following information: employee number, last name, first name, and department name.

select employees.emp_no as "employee number", employees.last_name as "last name", employees.first_name as "first name", departments.dept_name as "department name"
from employees
inner join dept_emp on 
employees.emp_no= dept_emp.emp_no
inner join departments on
dept_emp.dept_no=departments.dept_no;

-- List first name, last name, and sex for employees whose first name is "Hercules" and last names begin with "B."
select first_name, last_name, gender
from employees
where first_name = 'Hercules'and last_name like 'B%';

-- List all employees in the Sales department, including their employee number, last name, first name, and department name.

select dept_emp.emp_no as "employee number",
employees.last_name as "last name", employees.first_name as "first name", departments.dept_name as "department name"
from dept_emp
inner join employees on
dept_emp.emp_no = employees.emp_no
inner join departments on
dept_emp.dept_no = departments.dept_no
where departments.dept_name = 'Sales';

-- List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
select dept_emp.emp_no as "employee number",
employees.last_name as "last name", employees.first_name as "first name", departments.dept_name as "department name"
from dept_emp
inner join employees on
dept_emp.emp_no = employees.emp_no
inner join departments on
dept_emp.dept_no = departments.dept_no
where departments.dept_name = 'Sales' or dept_name = 'Development';


-- In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.

select employees.last_name, 
count(last_name) as "frequency"
from employees
group by last_name
order by count(last_name) desc;