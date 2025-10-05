use hr;

-- Write a stored procedure to retrieve all employees from the Employees table for a given department ID.
delimiter $$
create procedure retrieve_id(in input_dept_id int)
begin 
  select * from employees where department_id = input_dept_id;
end $$
delimiter ; 
call retrieve_id(100);
  


-- Create a function that calculates the total salary expenditure for a given department ID.
delimiter $$
create function total_expenditure(input_dept_id int)
returns int
deterministic 
begin 
    declare total_salary int ;
    select sum(salary) into total_salary
    from employees
    where department_id= input_dept_id;
    return total_salary;
end ;;
$$
delimiter ;

select total_expenditure(100);


-- Develop a stored procedure that accepts an employee ID as an input parameter and increases the salary of that employee by a specified percentage.
delimiter $$ 
create procedure increase_salary(in input_emp_id int, in input_percen decimal (6,2)) 
begin 
     update employees 
     set salary = salary + (salary * (input_percen / 100) )
     where employee_id = input_emp_id;

end $$
delimiter ; 
call increase_salary(100, 10.0);

select * from employees;

-- Write a function to determine the average salary for employees in a specific job title category.
delimiter $$ 
create function  fun_average_salry(inp_job_title varchar(50))
returns decimal(10,2)
deterministic
begin 
       declare cal_avg_sal decimal(10,2);
       select avg(salary) into cal_avg_sal
       from employees e
       join jobs j on j.job_id=e.job_id
       where j.JOB_TITLE = inp_job_title;
       return cal_avg_sal;
end;; 
$$
delimiter ; 

select * from jobs;
select fun_average_salry('Programmer');


-- Create a stored procedure that takes an employee's first name and last name as input parameters and returns the full name in uppercase letters.
delimiter $$
create procedure emp_full(in in_first_name varchar(20), in in_last_name varchar(20))
begin 
     select upper(concat(first_name ,'-',last_name)) as full_name 
     from employees
     where first_name = in_first_name and last_name = in_last_name;
end ;
$$
delimiter ;
select * from employees ;
call emp_full("steven","king");



-- Write a stored procedure to insert a new employee into the Employees table with the provided first name, last name, and department ID.
delimiter $$
create procedure inse_new_emp(in in_f_name varchar(20), in in_l_name varchar(20), in in_d_id decimal(4,0))
begin 
     insert into employees(first_name , last_name , department_id)
     values(in_f_name, in_l_name , in_d_id);
end ;
$$
delimiter ; 
call inse_new_emp('sagar','patidar',600);
 
 
-- Create a function to calculate the total number of employees in a specific department.
delimiter $$
create function total_emp(in_d_id int )
returns int 
deterministic
begin
     declare cnt int; 
     select count(DEPARTMENT_ID) into cnt
     from employees 
     where DEPARTMENT_ID = in_d_id;
     return cnt;
end;;
$$
delimiter ;
select * from employees;
select total_emp ( 100 ) ;


-- Develop a stored procedure that accepts an employee ID as input and deletes that employee's record from the Employees table.
delimiter $$
create procedure del_emp(in in_e_id decimal(6,0))
begin 
    delete from employees 
    where employee_id = in_e_id;
end;;
$$
delimiter ;
call del_emp(100);
select * from employees;

-- Write a function to determine the highest salary in the Employees table.
delimiter $$
create function high_sal_in_emp()
returns float
deterministic
begin 
     declare max_sal float;
     select max(salary) into max_sal
     from employees;
     return max_sal;
end ;;
$$
delimiter ;
select high_sal_in_emp();

-- Create a stored procedure that takes a department ID as an input parameter and 
-- returns the list of employees sorted by their salary in descending order within that department.
delimiter $$
create procedure sorted_emp_sal(in in_d_id decimal(4,0))
begin
     select salary 
     from employees
     where department_id = in_d_id
     order by salary desc;
end ; 
$$
delimiter ;
call sorted_emp_sal(80);
-- Write a stored procedure to update the job title of an employee based on their employee ID.
delimiter $$
create procedure update_emp_by_title(in in_emp_id int, in in_j_title varchar(50))
begin 
     update jobs j join 
     employees e on e.job_id =j.job_id
     set JOB_TITLE = in_j_title
     where e.employee_id = in_emp_id;

end;
$$
delimiter ;

select j.job_title , e.employee_id
from employees e join jobs j on j.job_id=e.job_id
where e.employee_id = 101;

call update_emp_by_title(101, "information");

select j.job_title , e.employee_id
from employees e join jobs j on j.job_id=e.job_id
where e.employee_id = 101;

-- Create a function that returns the number of employees hired in a specific year.
delimiter $$
create function num_of_emp_year(in_year int)
returns int
deterministic
begin  
     declare cnt int;
     select count(employee_id) into cnt
     from employees 
     where year(hire_date) = in_year;
     return cnt;
end ;;
$$
delimiter ; 
select * from employees;
select num_of_emp_year(1987);

-- Develop a stored procedure that accepts an employee ID as input and 
-- retrieves the employee's details, including their name, department, and salary.

delimiter $$
create procedure emp_details_based_on_emp_id(in in_e_id decimal(6,0))
begin 
     select concat(e.first_name,' ', e.last_name) as full_name , d.department_name, e.salary
     from employees e join departments d on d.department_id = e.DEPARTMENT_ID
     where e.employee_id = in_e_id;
end;;
$$
delimiter ;
call emp_details_based_on_emp_id(111);

-- Write a function to calculate the average tenure (in years) of employees in the company.
delimiter $$ 
create function fn_avg_tenure()
returns decimal(10,0)
deterministic 
begin 
      declare avg_tenure decimal(10,0);
      select  ROUND(AVG(DATEDIFF(COALESCE(ExitDate, CURRENT_DATE),JoinDate) / 365.0), 2) into avg_tenure
      from employees ;
      return avg_tenure;
end;;
$$
delimiter ;
select fn_avg_tenure();

-- Create a stored procedure that takes a department ID as an input parameter and returns 
-- the department name along with the count of employees in that department.
delimiter $$
create procedure pr_count_emp_in_emp(in_d_id int )
begin  
     select d.department_name, count(e.employee_id) as no_of_emp
     from employees e join departments d on d.department_id = e.department_id
     where d.department_id = in_d_id
     group by 1 ;
end;;
$$
delimiter ; 
set @in_d_id =90 ;
call pr_count_emp_in_emp(@in_d_id);


-- Write a stored procedure to retrieve the top N highest-paid employees in the company, where N is an input parameter.
delimiter $$
create procedure pr_top_high_emp(in N int )
begin 
      select first_name , last_name , salary
      from employees
      order by salary desc
      limit N;
end;;
$$
delimiter ; 
call pr_top_high_emp(5);


-- Create a function that calculates the total bonus amount for all employees based on their performance ratings.
delimiter $$
create function fn_total_bonus(in_per_rating varchar(20))
returns int
deterministic
begin  
     declare total_bonus int ;
     case rating 
          when 'excellent' then set bonus = 1000;
          when 'good' then set bonus = 700;
          when 'average ' then set bonus = 400;
          else set bonus = 0 ;
     end case;     
     return total_bonus;
end;;
$$
delimiter ;

select fn_total_bonus(in_per_rating) as bonus from employees;
-- Develop a stored procedure that accepts a salary threshold as an input parameter and retrieves all employees with salaries above that threshold.
delimiter $$
create procedure pr_threshold(in in_threshold int )
begin 
   select salary from employees
   where salary > in_threshold;
end;;
$$
delimiter ;
set @in_threshold = 10000;
call  pr_threshold(@in_threshold);




-- Write a function to determine the average age of employees in the company based on their birthdates.
delimiter $$
create function fn_average_emp(in_birthdaydate int)
returns decimal(10,2)
deterministic
begin 
     declare avg_age decimal(10,2);
     select avg(timestampdiff(year, in_birthdaydate, curdate())) into avg_age
     from employees;
     return avg_age;
end ;;
$$
delimiter ; 
set @in_birthdaydate = '2003-08-25';
select fn_average_emp(@in_birthdaydate);




-- Create a stored procedure that takes an employee's last name as an 
-- input parameter and returns all employees with a similar last name.
delimiter $$
create procedure pr_similar_name(in in_last_name varchar(50))
begin  
     select last_name from employees where last_name = in_last_name ;
end;;
$$
delimiter ; 
set @in_last_name = "smith";
call pr_similar_name(@in_last_name);



-- Write a stored procedure to update the email address of an employee based on their employee ID.
delimiter $$
create procedure pr_update_email(in in_emp_id decimal(6,0))
begin
     update employees 
     set email = "abc@gmail.com"
     where employee_id = in_emp_id;
end;;
$$ 
delimiter ;
set @in_emp_id = 101;
call pr_update_email(@in_emp_id);
select email from employees;

-- Create a function that calculates the total experience (in years) of all employees combined in the company.
delimiter $$
create function fn_cal_total_exp()
returns int
deterministic 
begin  
    declare total_exp int;
    select timestampdiff(year,hire_date, curdate()) into total_exp 
    from employees;
    return ifnull(total_exp,0);
end;;
$$
delimiter ; 
select fn_cal_total_exp() as total_exp;

 
-- Develop a stored procedure that accepts a department ID as input and returns the department name along with the average salary of employees in that department.
delimiter $$ 
create procedure pr_dep_details(in in_dept_id decimal(4,0))
begin 
     select  d.department_name, avg(e.salary) as avg_salary
     from employees e join departments d on d.department_id = e.department_id
     where d.department_id = in_dept_id 
     group by 1;
end;;
$$
delimiter ; 
call pr_dep_details(80);



-- Write a function to determine the number of employees who have been with the company for more than a specified number of years.
delimiter $$
create function fn_yearswithcompany(in_years int )
returns int 
deterministic
begin 
     declare total_employee int; 
     select  count(employee_id) into total_employee 
     from employees 
     where timestampdiff(year, hire_date , curdate()) > in_years;
     return total_employee;
end;;
$$
delimiter ;

select fn_yearswithcompany(22);


-- Create a stored procedure that takes a job title as an input parameter and returns the count of employees holding that job title.

delimiter $$ 
create procedure pr_emp_in_title(in in_job_title varchar(40))
begin 
     select  count(e.employee_id) 
     from   employees e join jobs j on j.job_id = e.job_id
     where   j.job_title = in_job_title;
end;;
$$
delimiter ; 
call pr_emp_in_title('marketing manager');
select * from jobs;



-- Write a stored procedure to retrieve the details of employees who have a salary within a specified range.

delimiter $$ 
create procedure pr_emp_in_range(in in_s1 decimal(10,0), in in_s2 decimal(10,2))
begin 
     select * from   employees
     where salary between in_s1 and in_s2 ;
end;;
$$
delimiter ; 
call pr_emp_in_range(1000, 2500);


-- Create a function that calculates the total number of working hours for an employee in a given month.
DELIMITER //
CREATE FUNCTION fn_monthly_work_hours(emp_id INT, target_year INT, target_month INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE total_hours INT DEFAULT 0; DECLARE start_date DATE; DECLARE end_date DATE; DECLARE current_date DATE;
    SET start_date = STR_TO_DATE(CONCAT(target_year, '-', target_month, '-01'), '%Y-%m-%d');
    SET end_date = LAST_DAY(start_date);

    SET current_date = start_date;

    WHILE current_date <= end_date DO
        IF DAYOFWEEK(current_date) NOT IN (1, 7) THEN
            IF EXISTS 
                      (SELECT 1 FROM employees WHERE id = emp_id AND hire_date <= current_date) THEN
			          SET total_hours = total_hours + 8;
            END IF;
        END IF;
        SET current_date = DATE_ADD(current_date, INTERVAL 1 DAY);
    END WHILE;

    RETURN total_hours;
END //

DELIMITER ;
SELECT fn_monthly_work_hours(101, 2025, 10) AS working_hours;


use hr;
-- Develop a stored procedure that accepts an employee ID as input and retrieves the employee's department name and manager's name.
delimiter $$
create procedure prempployee_details(in in_emp_id decimal(6,0))
begin  
     select e.manager_id , d.department_name 
     from employees e join departments d on d.department_id = e.department_id
     where employee_id = in_emp_id;
end;;
$$
delimiter ; 
call prempployee_details(101);


-- Write a function to determine the total number of employees hired in each year, grouped by the year of hire.
delimiter $$ 
create function fn_get_employee(in_year varchar(4))
returns int 
deterministic
begin  
     declare total_emp int;
     select count(employee_id) into total_emp
     from employees
     where year(hire_date) = in_year
     group by year(hire_date);
     return total_emp;
end;;
$$
delimiter ; 
select fn_get_employee('1987');


-- Create a stored procedure that takes a city name as an input parameter and returns the list of employees residing in that city.
delimiter $$
create procedure pr_residing_emp(in in_city varchar(40))
begin 
     select e.first_name , e.last_name 
     from employees e join departments d on d.department_id = e.department_id
     join locations l on l.location_id = d.location_id
     where l.city =  in_city;
end;;
$$
delimiter ;

set @in_city = 'london';
call pr_residing_emp(@in_city);



-- Write a stored procedure that calculates the average salary increase percentage for employees who have been with the company for more than five years.
delimiter $$
create procedure pr_avg_cal_sal_emp(in in_percentage decimal(6,2))
begin 
     select avg(salary) * in_percentage as avg_increased_percentage
     from employees
     where timestampdiff(year, hire_date, curdate()) > 5;
end ;;
$$
delimiter ; 
call  pr_avg_cal_sal_emp(1.10);

select avg(salary) from employees;

select * from departments;
-- Create a function that calculates the total sales revenue generated by each employee in the Sales department, considering both individual and team contributions.
delimiter $$
create function fn_cal_total_sales_revenue(d_name varchar(25))
returns decimal(10,2)
deterministic
begin 
        declare total_sales_revenue decimal(10,2);
        SELECT e.employee_id, e.first_name, e.individual_sales + e.team_sales into total_sales_revenue
        FROM employees e join departments d on d.department_id= e.department_id
        WHERE d.department_name = d_name;
end;;
$$
delimiter ;
set @d_name = 'sales' ;
select fn_cal_total_sales_revenue(@d_name);


-- Develop a stored procedure that accepts a date range as input and retrieves all 
-- employee attendance records within that period, including late arrivals and early departures.
DELIMITER $$
create procedure  GetAttendanceRecords( IN start_date DATE, IN end_date DATE )
begin
    select a.attendance_date, e.employee_id, e.name, e.department, a.check_in,a.check_out,
	case
	   when a.check_in > '09:00:00' then 'Yes' else 'No'
	end as late_arrival,
	case
	   when a.check_out < '17:00:00' then 'Yes' else 'No'
	end as  early_departure
    from attendance a inner join employees e on a.employee_id = e.employee_id
    where a.attendance_date between start_date and end_date
    order by  a.attendance_date, e.employee_id;
end ;; $$
DELIMITER ;



-- Write a function that determines the average number of projects handled by employees in each department and identifies departments with exceptionally high or low project volumes.
DELIMITER $$

CREATE FUNCTION GetProjectVolumeSummary()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE done INT DEFAULT FALSE;
    DECLARE dept_name VARCHAR(50);
    DECLARE avg_projects DECIMAL(5,2);
    DECLARE status VARCHAR(20);

    -- Cursor to loop through department-wise averages
    DECLARE cur CURSOR FOR
        SELECT 
            department,
            AVG(project_count) AS avg_proj
        FROM 
            employees
        GROUP BY 
            department;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;

    OPEN cur;

    read_loop: LOOP
        FETCH cur INTO dept_name, avg_projects;
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Flagging based on thresholds
        IF avg_projects >= 10 THEN
            SET status = 'High Volume';
        ELSEIF avg_projects <= 3 THEN
            SET status = 'Low Volume';
        ELSE
            SET status = 'Normal';
        END IF;

        SET result = CONCAT(result, dept_name, ': Avg Projects = ', avg_projects, ' → ', status, '\n');
    END LOOP;

    CLOSE cur;

    RETURN result;
END$$

DELIMITER ;



-- Create a stored procedure that takes a job title as an input parameter and returns the list of employees holding that job title, 
-- along with the total compensation considering bonuses and allowances.
DELIMITER $$
CREATE PROCEDURE GetCompensationByJobTitle( IN input_job_title VARCHAR(100))
BEGIN
    SELECT e.employee_id, e.first_name,j.job_title, e.salary, e.bonus, e.allowance,(e.salary + e.bonus + e.allowance) AS total_compensation
    FROM employees e join jobs j on j.job_id = e.job_id
    WHERE j.job_title = input_job_title;
END$$
DELIMITER ;

-- Write a stored procedure that calculates the performance rating for each employee based on various criteria, such as project completion, client feedback, and adherence to deadlines.
DELIMITER $$
CREATE PROCEDURE CalculatePerformanceRatings()
BEGIN
    SELECT employee_id, first_name, project_completion, client_feedback, deadline_adherence,
        ROUND((project_completion * 0.4) + (client_feedback * 10 * 0.3) + (deadline_adherence * 0.3), 2) AS performance_rating
    FROM  employee_performance
    ORDER BY performance_rating DESC;
END $$
DELIMITER ;
-- Create a function that determines the average time taken to resolve customer issues for each support agent, considering different issue categories and urgency levels.
DELIMITER $$
CREATE FUNCTION GetAvgResolutionTimeSummary()
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE done INT DEFAULT FALSE;
    DECLARE agent_name VARCHAR(100);
    DECLARE avg_minutes DECIMAL(10,2);

    -- Cursor to loop through agent-wise average resolution time
    DECLARE cur CURSOR FOR
        SELECT sa.agent_name, AVG(TIMESTAMPDIFF(MINUTE, si.reported_time, si.resolved_time)) AS avg_resolution_minutes
        FROM support_issues si
        JOIN support_agents sa ON si.agent_id = sa.agent_id
        GROUP BY sa.agent_name;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO agent_name, avg_minutes;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SET result = CONCAT(result, agent_name, ': Avg Resolution Time = ', ROUND(avg_minutes, 2), ' minutes\n');
    END LOOP;
    CLOSE cur;
    RETURN result;
END$$
DELIMITER ;


-- Develop a stored procedure that accepts a date range and a specific project ID as input and 
-- retrieves all employee work hours dedicated to that project within the given period.
DELIMITER $$
CREATE PROCEDURE GetProjectWorkHours(IN input_project_id INT,IN start_date DATE,IN end_date DATE)
BEGIN
    SELECT wl.work_date, e.employee_id, e.name,e.department, wl.hours_worked
    FROM work_logs wl
    JOIN employees e ON wl.employee_id = e.employee_id
    WHERE wl.project_id = input_project_id
	AND wl.work_date BETWEEN start_date AND end_date
    ORDER BY wl.work_date, e.employee_id;
END$$
DELIMITER ;
CALL GetProjectWorkHours(101, '2025-09-01', '2025-09-30');



-- Write a function that calculates the employee turnover rate for each department, considering the number of new hires and the number of departures over a specified time frame.
DELIMITER $$
CREATE FUNCTION GetTurnoverRateSummary(start_date DATE, end_date DATE)
RETURNS TEXT
DETERMINISTIC
BEGIN
    DECLARE result TEXT DEFAULT '';
    DECLARE done INT DEFAULT FALSE;
    DECLARE dept VARCHAR(50);
    DECLARE hires INT;
    DECLARE exits INT;
    DECLARE existing INT;
    DECLARE turnover DECIMAL(5,2);
    DECLARE cur CURSOR FOR
        SELECT department FROM employees GROUP BY department;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO dept;
        IF done THEN
            LEAVE read_loop;
        END IF;
        SELECT COUNT(*) INTO hires
        FROM employees
        WHERE department = dept AND hire_date BETWEEN start_date AND end_date;
        SELECT COUNT(*) INTO exits
        FROM employees
        WHERE department = dept AND termination_date BETWEEN start_date AND end_date;
        SELECT COUNT(*) INTO existing
        FROM employees
        WHERE department = dept AND hire_date < start_date AND (termination_date IS NULL OR termination_date >= start_date);
        IF (existing + hires) > 0 THEN
            SET turnover = (exits / (existing + hires)) * 100;
        ELSE SET turnover = 0;
        END IF;
        SET result = CONCAT(result, dept, ': Turnover Rate = ', ROUND(turnover, 2), '%\n');
    END LOOP;
    CLOSE cur;
    RETURN result;
END$$
DELIMITER ;
SELECT GetTurnoverRateSummary('2025-01-01', '2025-09-30');


-- Create a stored procedure that takes a location as an input parameter and returns the list of employees 
-- who have been involved in projects related to that location, along with their project contributions and performance ratings.
DELIMITER $$
CREATE PROCEDURE GetEmployeesByProjectLocation( IN input_location VARCHAR(100))
BEGIN
    SELECT e.employee_id, e.name, e.department, p.project_name, ep.contribution, ep.performance_rating
    FROM  employee_projects ep
    JOIN  employees e ON ep.employee_id = e.employee_id
    JOIN  projects p ON ep.project_id = p.project_id
    WHERE p.location = input_location
    ORDER BY e.employee_id, p.project_name;
END$$
DELIMITER ;
CALL GetEmployeesByProjectLocation('Mumbai');
