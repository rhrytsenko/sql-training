/*

Лінк на задачу: https://platform.stratascratch.com/coding/10313-naive-forecasting?code_type=1

Умови:

1. Задача від Uber. Відповідно дані - це інформація щодо поїздок
2. Серед наявних даних:  request_id 
                         request_date
                         request_status
                         distance_to_travel 
                         monetary_cost
                         driver_to_client_distance

Що треба зробити:

1. Розрахувати величину "distance per dollar"
2. На її основі зробити т.зв. "наївний прогноз"
3. Розрахувати кореневе середньоквадратичне відхилення (RSME) для наївного прогнозу

Теорія:

Наївний прогноз - це прогноз, який дорівнює значенню, що спостерігалося за попередній період
RSME (у нашому випадку) - це стандартне відхилення помилки прогнозу. Цей показник розраховується за формулою:

sqrt(avg(power(actual - forecast)))

Задача розв'язується в три кроки. Для наочності після кожного кроку залишатиму перші декілька рядків результуючої таблиці

*/


Перший крок

select 
    -- (1) округлюємо дати до місяців
    date_trunc ('month', request_date) as month
    -- (2) рахуємо місячні вартість та відстань перевезень
    ,sum (distance_to_travel) as sum_distance
    ,sum (monetary_cost) as sum_cost
from uber_request_logs
group by 1

-- Результат:

month                 sum_distance   sum_cost
2020-09-01 00:00:00   49.12          37
2020-07-01 00:00:00   81.47          31.44
2020-10-01 00:00:00   129.09         45.98
2020-04-01 00:00:00   72.67          23.89


Другий крок

-- (1) зберігаємо попередній скрипт як окрему таблицю (month_table)
with month_table as
    (select 
        date_trunc ('month', request_date) as month
        ,sum (distance_to_travel) as sum_distance
        ,sum (monetary_cost) as sum_cost
    from uber_request_logs
    group by 1)

select 
    month
    -- (2) розраховуємо в окрему колонку величину distance_per_dollar
    ,(sum_distance / sum_cost) as distance_per_dollar
    -- (3) переносимо в окрему колонку прогноз і зміщуємо його на один місяць вперед
    ,lag(sum_distance / sum_cost, 1) over (order by month) as naive_forecast
from month_table
order by 1

-- Результат:

month                  distance_per_dollar    naive_forecast
2020-01-01 00:00:00    5.607                  N/A
2020-02-01 00:00:00    5.806                  5.607
2020-03-01 00:00:00    5.949                  5.806
2020-04-01 00:00:00    3.042                  5.949

/* Важливо. Залишаємо першу клітинку у "зміщеному" прогнозі порожньою (як null value). Якщо заповнити її нулем, ми
не зможемо коректно розрахувати середнє значення для RSME. Адже відсутність значення і значення "0" даватимуть різні
результати */

Третій крок. 

with month_table as
    (select 
        date_trunc ('month', request_date) as month
        ,sum (distance_to_travel) as sum_distance
        ,sum (monetary_cost) as sum_cost
    from uber_request_logs
    group by 1),

-- (1) зберігаємо прогноз як окрему таблицю (forecast_table)
forecast_table as
    (select 
        month
        ,(sum_distance / sum_cost) as distance_per_dollar
        ,lag(sum_distance / sum_cost, 1) over (order by month) as naive_forecast
    from month_table
    order by 1)

select
    -- (2) розраховуємо значення RSME (підносимо до другого степеня різницю між фактичними даними і прогнозом,
    -- усереднюємо результат і вираховуємо з того, що вийшло, квадратний корінь)
    sqrt(avg(power(distance_per_dollar - naive_forecast, 2))) as rmse
from forecast_table

-- Результат:

rmse
2.337
