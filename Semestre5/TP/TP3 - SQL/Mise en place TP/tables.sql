CREATE FUNCTION updatesalaries() RETURNS trigger
    LANGUAGE plpgsql
    AS $$BEGIN
   IF NEW.salary <> OLD.salary THEN
    INSERT INTO salary_changes(employee_id,old_salary,new_salary,modifiant)
        VALUES(NEW.employee_id,OLD.salary,NEW.salary,current_user);
    END IF;
RETURN NEW;
END;

$$;

CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name character varying(25)
);

CREATE TABLE countries (
    country_id character(2) PRIMARY KEY,
    country_name character varying(40),
    region_id integer NOT NULL REFERENCES regions
);

CREATE TABLE locations (
    location_id SERIAL PRIMARY KEY,
    street_address character varying(40),
    postal_code character varying(12),
    city character varying(30) NOT NULL,
    state_province character varying(25),
    country_id character(2) NOT NULL REFERENCES countries
);

CREATE TABLE departments (
    department_id SERIAL PRIMARY KEY,
    department_name character varying(30) NOT NULL,
    location_id integer REFERENCES locations
);

-- Ne sert pas dans le TP3

CREATE TABLE jobs (
    job_id SERIAL PRIMARY KEY,
    job_title character varying(35) NOT NULL,
    min_salary numeric(8,2),
    max_salary numeric(8,2)
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name character varying(20),
    last_name character varying(25) NOT NULL,
    email character varying(100) NOT NULL,
    phone_number character varying(20),
    hire_date date NOT NULL,
    job_id integer NOT NULL REFERENCES jobs,
    salary numeric(8,2) NOT NULL,
    manager_id integer REFERENCES employees,
    department_id integer REFERENCES departments
);

CREATE TABLE dependents (
    dependent_id SERIAL PRIMARY KEY,
    first_name character varying(50) NOT NULL,
    last_name character varying(50) NOT NULL,
    relationship character varying(25) NOT NULL,
    employee_id integer NOT NULL REFERENCES employees
);


CREATE TABLE salary_changes (
    employee_id integer NOT NULL,
    changed_at timestamp(4) with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    old_salary numeric(8,2),
    new_salary numeric(8,2),
    modifiant text
);

CREATE TRIGGER after_update_salary AFTER UPDATE ON employees FOR EACH ROW EXECUTE PROCEDURE updatesalaries();