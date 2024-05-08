/*

Лінк: https://platform.stratascratch.com/coding/10077-income-by-title-and-gender?code_type=1

Опис:

1. Задача від адміністрації Сан-Франциско. Треба знайти середню зарплату в місті за гендером та посадою

Умови:

1. Повна зарплата складається із основної зарплати і бонусів
2. Не кожен співробітник отримує бонуси. Тих, хто їх не отримує, не слід включати в розрахунки
3. У той же час, один співробітник може отримувати декілька бонусів
4. Інформація для розрахунків розведена по двох таблицях
5. У результуючій таблиці мають бути колонки employee title, sex та average total compensation

Задачу можна розв'язати як за допомогою CTE, так і вкладеним запитом в join clause

*/

Варіант 1

-- (2) другий запит, у якому додаємо до основної зарплати суму бонусів, яку рахували в першому запиті.
-- Результат усереднюємо функцією avg
select
    e.employee_title,
    e.sex,
    avg(e.salary + b.total_bonus) as avg_salary
from sf_employee e
-- (3) з'єднуємо підзапитом перший запит з другим
join
    -- (1) перший запит, у якому сумуємо всі бонуси кожного окремого співробітника.
    (select 
        worker_ref_id
        ,sum(bonus) as total_bonus
    from sf_bonus
    group by 1) b
on e.id = b.worker_ref_id
-- (4) групуємо результат по колонках employee title та sex
group by 1,2

Варіант 2

-- механіка аналогічна варіанту 1, але перший запит зберігається як окрема таблиця bonus_table, 
-- а не як підзапит в join clause

with bonus_table as
(select 
    worker_ref_id
    ,sum (bonus) as total_bonus
from sf_bonus
group by 1)

select 
    employee_title
    ,sex
    ,avg (salary + total_bonus) as avg_salary
from bonus_table b
join sf_employee e
on b.worker_ref_id = e.id
group by 1,2
