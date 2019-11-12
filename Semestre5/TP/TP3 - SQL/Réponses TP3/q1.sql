WITH RECURSIVE manage(employee, manager) AS (
    SELECT employee_id, manager_id
    FROM employees
    
    UNION
    
    SELECT manager, manager_id
    FROM employees
    JOIN manage ON
	(manager=employees.manager_id)
)
    
SELECT employee, manager
FROM manage
GROUP BY 1, 2
ORDER BY 1, 2;