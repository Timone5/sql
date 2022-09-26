set schema 'internet-shop';

create table items (id integer primary key, name varchar(80), description varchar(200), producer_id integer, amount integer);
create table producers (id integer primary key, name varchar(100), address varchar(200));
create table customers (id integer primary key, name varchar(50), surname varchar(100));
create table shipping_addresses (id integer primary key, customer_id integer, city varchar(100), street varchar(100), building varchar (5));
create table orders (id integer primary key, customer_id integer, address_id integer);
create table orders_content (order_id integer, item_id integer, amount integer);

insert into producers (id, name, address) values (1, 'Мир мебели', 'Москва');
insert into producers (id, name, address) values (2, 'Great Chair', 'Польша');
insert into producers (id, name, address) values (3, '1000 диванов', 'Новороссийск');

insert into items (id, name, description, producer_id, amount) values (1, 'Стол письменный "Салют"', 'Большой удобный письменный стол', 1, 10);
insert into items (id, name, description, producer_id, amount) values (2, 'Шкаф для одежды', 'Простой шкаф с тремя полками', 1, 8);
insert into items (id, name, description, producer_id, amount) values (3, 'Кресло-качалка базовое', 'Кресло-качалка с деревянной базой и тканевой обивкой', 2, 12);
insert into items (id, name, description, producer_id, amount) values (4, 'Диван односпальный база', NULL, 3, 84);
insert into items (id, name, description, producer_id, amount) values (5, 'Диван "Люкс"', 'Диван повышенной комфортности для ценителей', 3, 6);

insert into customers(id, name, surname) values (1, 'Дмитрий', 'Сергеев');
insert into customers(id, name, surname) values (2, 'Ирина', 'Максимова');
insert into customers(id, name, surname) values (3, 'Вячеслав', 'Феоктистов');

insert into shipping_addresses (id, customer_id, city, street, building) values (1, 1, 'Москва', 'Ленинский проспект', '19');
insert into shipping_addresses (id, customer_id, city, street, building) values (2, 2, 'Москва', 'Кутузовский проспект', '24');
insert into shipping_addresses (id, customer_id, city, street, building) values (3, 2, 'Москва', 'ул. Беговая', '12');
insert into shipping_addresses (id, customer_id, city, street, building) values (4, 3, 'Санкт-Петербург', 'Литейный проспект', '42');

insert into orders (id, customer_id, address_id) values (1, 1, 1);
insert into orders (id, customer_id, address_id) values (2, 1, 1);
insert into orders (id, customer_id, address_id) values (3, 1, 1);
insert into orders (id, customer_id, address_id) values (4, 2, 2);
insert into orders (id, customer_id, address_id) values (5, 2, 3);
insert into orders (id, customer_id, address_id) values (6, 2, 2);
insert into orders (id, customer_id, address_id) values (7, 3, 4);
insert into orders (id, customer_id, address_id) values (8, 3, 4);

insert into orders_content (order_id, item_id, amount) values (1, 2, 1);
insert into orders_content (order_id, item_id, amount) values (2, 4, 1);
insert into orders_content (order_id, item_id, amount) values (2, 5, 1);
insert into orders_content (order_id, item_id, amount) values (3, 1, 2);
insert into orders_content (order_id, item_id, amount) values (4, 1, 1);
insert into orders_content (order_id, item_id, amount) values (4, 2, 1);
insert into orders_content (order_id, item_id, amount) values (4, 3, 1);
insert into orders_content (order_id, item_id, amount) values (5, 4, 1);
insert into orders_content (order_id, item_id, amount) values (6, 4, 1);
insert into orders_content (order_id, item_id, amount) values (6, 5, 1);
insert into orders_content (order_id, item_id, amount) values (7, 1, 1);
insert into orders_content (order_id, item_id, amount) values (8, 3, 1);
insert into orders_content (order_id, item_id, amount) values (8, 4, 1);
*/

-- 1. Вывести имена и фамилии всех покупателей
select name, surname
from customers;

-- 2. Для каждого товара вывести доступный остаток, отсортировать по убыванию остатка
select i.name, i.amount
from items i
order by i.amount DESC;

-- 3. Отобразить все товары, для которых заполнено описание
select name, description
from items
where description is not null;

-- 4. Отобразить список id покупателей, для которых существует хотя бы один заказ
select c.id
from customers c
         left join orders o
                   on c.id = o.customer_id
group by c.id
having count(customer_id) > 0;


-- 5. Вывести информацию о всех диванах (где название или описание начинается со слова "диван")
select name, description
from items
where name like 'Диван%'
   or name like 'диван%'
   or description like 'диван%'
   or description like 'Диван%';


-- 6. Вывести все товары поставщика "1000 диванов"
select i.name, i.description, p.name
from items i
         join producers p
              on i.producer_id = p.id
where p.name = '1000 диванов';


-- 7. Выбрать данные обо всех заказах (id заказа, название товара, заказанное количество, имя и фамилия покупателя, город и улица доставки)
select o.id order_id, i.name item_title, oc.amount purchased_amt, c.name customer_name, c.surname customer_surname, sa.city ship_city, sa.street ship_street
from orders o
         join orders_content oc on o.id = oc.order_id
         join items i on oc.item_id = i.id
         join customers c on o.customer_id = c.id
         join shipping_addresses sa on c.id = sa.customer_id;


-- 8. Для каждого покупателя вывести данные обо всех его адресах
select c.name, c.surname, sa.city, sa.street
from customers c
         join shipping_addresses sa
              on c.id = sa.customer_id;


-- 9. Вывести список всех городов, из которых присутствует либо покупатель, либо поставщик
select sa.city, 'Город покупателя' contragent
from shipping_addresses sa
union
select p.address, 'Город поставщика'
from producers p;


-- 10. Добавить нового покупателя (без заказов)
insert into customers (id, name, surname)
values (4, 'Тони', 'Старк');


-- 11. Для каждого покупателя вывести количество заказов
select c.name, c.surname, count(o.customer_id)
from customers c
         join orders o on c.id = o.customer_id
group by c.name, c.surname
;


-- 12. Посчитать, сколько заказали экземпляров каждого товара
select i.name, sum(oc.amount)
from orders_content oc
         join items i on oc.item_id = i.id
group by i.name
;


-- 13. Вывести имена и фамилии всех покупателей, живущих в Москве (у которых там хотя бы один адрес)
select distinct c.name, c.surname
from customers c
         join shipping_addresses sa
              on c.id = sa.customer_id
where city = 'Москва';


-- 14. Найти, сколько было заказов на каждый адрес
select sa.city, sa.street, sa.building, sum(oc.amount)
from shipping_addresses sa
         join orders o on sa.id = o.address_id
         join orders_content oc on o.id = oc.order_id
group by sa.city, sa.street, sa.building
;


-- 15. * Для каждого поставщика отобразить общее проданное количество товаров
-- и доступный остаток
select distinct p.name producers, sum(oc.amount) sold_cnt, sum(distinct (i.amount)) available_cnt
from producers p
         join items i on p.id = i.producer_id
         join orders_content oc on i.id = oc.item_id
group by p.name
;


-- 15. * Альтернативное решение
select s.p_name, s.sold, t.total
from (select p.id as producer, sum(i.amount) as total
      from producers p
               join items i on p.id = i.producer_id
      group by p.id, p."name") t,
     (select p.id as producer, p."name" as p_name, sum(oc.amount) as sold
      from producers p
               join items i on i.producer_id = p.id
               join orders_content oc on oc.item_id = i.id
      group by p.id, p."name") s
where t.producer = s.producer
;
