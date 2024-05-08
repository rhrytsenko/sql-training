/* 

Лінк на задачу: https://platform.stratascratch.com/coding/10171-find-the-genre-of-the-person-with-the-most-number-of-oscar-winnings?code_type=1

Завдання:

1. Треба з'ясувати, у якому жанрі грав актор, який отримав найбільшу кількість Оскарів
2. Якщо таких людей буде декілька, треба вивести їх імена в алфавітному порядку

Опис і умови:

1. Задача від Netflix. 
2. Потрібна інформація "розкидана" по двом таблицям
3. Поєднувати таблиці можна за колонками з іменами акторів

Задачу можна вирішити декількома способами: більш розширеним (варіант 1) і більш компактним (варіант 2)

*/

Варіант 1

-- (4) зберігаємо результат як таблицю oscar_table
with oscar_table as 
-- (1) пишемо перший select-запит, у якому виводимо імена акторів з першої таблиці
(select
    nominee
    -- (2) у цьому ж запиті працюємо з boolean-колонкою winner. Виводимо в окрему колонку
    -- значення FALSE як 0 і значення TRUE як 1. Агрегуємо дані в новій колонці функцією sum 
    ,sum (case 
        when winner = 'FALSE' then 0
        when winner = 'TRUE' then 1
    end) as oscars_count
from oscar_nominees
-- (3) групуємо результат агрегації за колонкою nominee
group by 1
order by oscars_count desc)

select 
    name
    ,top_genre
    ,oscars_count
-- (5) об'єднуємо таблицю oscar_table з таблицею, де вказані жанри  
from nominee_information n
join oscar_table o
on o.nominee = n.name
-- (6) сортуємо к-сть оскарів та імена акторів
order by 3 desc, 1 asc

Варіант 2

-- у цьому варіанті вказані ті ж дії, що і у попередньому, але без використання CTE. Цей підхід дозволяє скоротити
-- скрипт на майже 10 рядків

select
    nominee
    ,top_genre
    ,sum (case 
        when winner = 'FALSE' then 0
        when winner = 'TRUE' then 1
    end) as oscars_count
from nominee_information n
join oscar_nominees o
on o.nominee = n.name
group by 1,2
order by 3 desc, 1 asc
