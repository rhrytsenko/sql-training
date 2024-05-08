/* 

Лінк: https://platform.stratascratch.com/coding/9782-customer-revenue-in-march?code_type=1

Опис і умови:

1. Задача від Amazon. Треба розрахувати загальний revenue для кожного клієнта
2. Розрахунки проводити тільки для березня 2019 року
3. У результуючу таблицю включати тільки тих клієнтів, які були активні у березні 2019
4. Вивести customer_id, revenue і відсортувати revenue у порядку спадання (Z-A)

Задача вирішується простим скриптом з агрегуючою функцією sum та групуванням за customer_id. 
У where clause, при цьому, можуть використовуватися декілька взаємозамінних функцій. 

*/

-- (1) Варіант з функцією extract, яка дістає потрібні частини дати

select 
    cust_id
    ,sum (total_order_cost) as total_rev_per_customer
from orders
where extract(month from order_date) = 3
    and extract(year from order_date) = 2019
group by 1
order by 2 desc

-- (2) Варіант з функцією cast, яка конвертує datetime у varchar, який потім фільтрується через like

select 
    cust_id
    ,sum (total_order_cost) as total_rev_per_customer
from orders
where cast (order_date as varchar) like '2019-03%'
group by 1
order by 2 desc

-- (3) Варіант з тією ж функцією cast, яка замінюється оператором ::

select 
    cust_id
    ,sum (total_order_cost) as total_rev_per_customer
from orders
where order_date::varchar like '2019-03%'
group by 1
order by 2 desc

-- (4) Варіант з простим фільтром через оператори ">=" та "<"

select 
    cust_id
    ,sum (total_order_cost) as total_rev_per_customer
from orders
where order_date >= '2019-03-01' 
    and order_date <'2019-04-01'
group by 1
order by 2 desc

-- (5) Варіант з фільтром через оператор between

select 
    cust_id
    ,sum (total_order_cost) as total_rev_per_customer
from orders
where order_date between '2019-03-01' and '2019-03-31'
group by 1
order by 2 desc
