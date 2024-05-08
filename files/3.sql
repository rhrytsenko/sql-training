/*

Лінк на задачу: https://platform.stratascratch.com/coding/10362-top-monthly-sellers?code_type=1

Умови:

1. У нас є датасет Amazon, у якому зібрана інформація щодо продажів різних продуктів у різних юрисдикціях

Що треба зробити:

1. знайти топ-3 продавців (за total_sales) для кожної групи товарів
2. поставити фільтр на час (січень 2024 року)
3. вивести колонки 'seller_id' , 'total_sales' ,'product_category' , 'market_place' та 'month'

Задача розв'язується через функцію rank()

*/


-- (4) щоб вивести всі колонки, крім sellers_rank, створюємо окремий запит до таблиці t1
-- і виводимо тільки те, що нам треба 
select 
    seller_id
    ,total_sales
    ,product_category
    ,market_place
    ,month
from
    -- (1) робимо перший запит і виводимо потрібні нам колонки
    (select
        seller_id
        ,total_sales
        ,product_category
        ,market_place
        ,month
        -- (2) ранжуємо колонки по категоріям товарів і сортуємо їх за total_sales (Z-A)
        ,rank () over
            (partition by product_category
            order by total_sales desc) as sellers_rank
    from
        sales_data
    -- (3) у цьому ж запиті ставимо фільтр на місяць і зберігаємо результат як окрему таблицю
    where month = '2024-01') as t1
-- (5) фільтр на топ-3 ставимо не через limit, а через where, щоб у підсумку у нас були дані по всім категоріям
where sellers_rank <= 3
