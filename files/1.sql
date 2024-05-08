/* 

Лінк на задачу: https://platform.stratascratch.com/coding/9894-employee-and-manager-salaries?code_type=1

Що треба зробити: 

1. Знайти співробітників, які заробляють більше за своїх менеджерів 
2. Вивести ім'я співробітника і його зарплату

Умови:

1. Задача від Walmart, Dropbox і Best Buy
2. Багато даних. Більша частина з них не важливі для вирішення задачі
3. Зарплата розбита на декілька частин (salary, target, bonus)
4. Деякі менеджери - підлеглі іншого менеджера. За таких умов співробітник дійсно може заробляти більше за менеджера 

Задачу можна вирішити декількома способами: через CTE (варіант 1) та звичайним підзапитом (варіант 2). 

*/

Варіант 1

-- (2) зберігаємо цей запит як окрему таблицю (manager_table)
with manager_table as
    -- (1) створюємо перший запит, у якому фільтруємо менеджерів
    (select 
        -- (3) даємо колонкам аліаси, щоб уникнути дубляжу в майбутньому
        salary as manager_salary
        ,first_name as manager_name
        ,id as personal_m_id
    from employee
    where employee_title = 'Manager')

-- (4) створюємо новий запит без фільтру менеджерів
select 
    -- (6) даємо колонкам унікальні для цього запиту аліаси
    e.salary as employee_salary
    ,e.first_name as employee_name
from employee e
-- (5) об'єднуємо новий запит з таблицею manager_table
join manager_table m
on m.personal_m_id = e.manager_id
-- (7) ставимо фільтр на зарплату
where e.salary > manager_salary

Варіант 2

select first_name, salary  
from employee 
where salary >  
    (select salary 
    from employee e 
    where e.id = manager_id)
