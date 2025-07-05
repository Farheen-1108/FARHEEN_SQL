create database library;
use library;

DROP TABLE IF EXISTS return_book;
DROP TABLE IF EXISTS Borrow;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS members_name;

-- create 

create table members_name(
member_id int primary key,
name varchar(50), 
email varchar(50),
contact_no bigint,
joining_date date );

create table Book(
book_id int primary key,
book_name varchar(50),
author_name varchar(50),
edition_num int,
gener varchar(50),
available_num int);

create table Borrow(
borrow_id int primary key,
member_id int,
book_id int,
borrow_date date,
foreign key (member_id) references members_name(member_id),
foreign key (book_id) references Book(book_id) 
);

create table return_book(
return_book_id int primary key,
return_book_name varchar(100),
return_date int,
fine_expands int);

-- insert:

insert into members_name(member_id,name,email,contact_no,joining_date)
values
(1, 'Jack' , 'jack@gmail.com' , 7865432043 , '2025-03-23' ),
(2, 'lilly' , 'lilly01@gmail.com' , 9834672650 , '2024-03-17'),
(3 , 'mercy' , Null , 7823490541 , "2025-01-23"),
(4, 'Neha ', 'neha@example.com', NULL, '2024-06-03'); 

insert into Book (book_id, book_name ,author_name, edition_num , gener ,available_num)
values
(101, 'Harry Potter', 'J.K. Rowling', 1, 'Fantasy', 5),
(102, 'I too have a love story', 'ravinder singh', 2, 'Romcom', 10),
(103, 'Five Point Someone', 'Chetan Bhagat', 1, 'Fiction', 3),
(104, '1984', 'George Orwell', 3, 'Dystopian', 2);

insert into Borrow (borrow_id ,member_id ,book_id ,borrow_date)
values
(1, 1, 101, '2025-03-23'),
(2, 2, 102, '2024-03-17'),
(3, 3, 103, '2025-01-23'),
(4, 4, 104, '2024-06-13');

insert into return_book(return_book_id ,return_book_name ,return_date ,fine_expands)
values
(1, 'Harry Potter', 10, 0),
(2, 'I too have a love story', 28 , 20),
(3, 'Five Point Someone', NULL, 50),  
(4, '1984', 7, 0);

-- update:

UPDATE members_name 
SET email = 'neha.@library.com'
WHERE member_id = 4;

UPDATE Book
SET available_num = 5
WHERE book_id = 102;

UPDATE Borrow
SET borrow_date = '2025-03-03'
WHERE member_id = 3; 

-- delete:

-- DELETE FROM Book WHERE book_id = 102;

-- DELETE FROM Borrow WHERE book_id = 104;

select * from members_name;
SELECT * FROM Book;
SELECT * FROM Borrow;
SELECT * FROM return_book;

select member_id , name from members_name;
select book_name , author_name , gener from Book;
select return_book_id ,return_book_name , fine_expands from return_book;

-- where

select name,joining_date from members_name where member_id = 4;
select return_book_name , return_date from return_book where return_book_id = 2;
select contact_no from members_name where joining_date > '2024-03-17';

-- where and and
select book_name, book_id from Book 
where gener = 'Fantasy' AND edition_num = 1;

-- where & OR

select borrow_id , member_id from Borrow
where book_id = 101 OR book_id = 102;

-- like "%":

select book_id , book_name , author_name from Book
where book_name LIKE '%H%';

-- between 
select return_book_name from return_book
where return_book_id between 1 and 3;

-- order by
select * from book 
order by edition_num desc;

select * from borrow
order by borrow_date asc ;

-- order by limit :

select * from members_name
order by joining_date limit 2;

select return_book_id, return_book_name from return_book
where fine_expands > 0 order by fine_expands desc ;

-- aggregrate:
-- count:
select count(*) AS total_count 
from members_name;

-- count group by:
select gener, count(*) as book_count
from Book group by gener;

-- average:
select gener, avg(available_num) as avg_available
from Book group by gener;

-- sum:
select sum(available_num) as tot_avail
from Book ;

-- having:
select author_name , count(*) as book_written
from Book group by author_name having count(*) = 1;

-- sum & group by :
select return_book_name ,sum(fine_expands) as fine
from return_book group by return_book_name ;

-- count & having:
select gener, avg(available_num) as avg_available
from Book group by gener having count(*) = 1;

-- INNER JOIN
SELECT
    m.member_id,
    m.name AS member_name,
    b.book_id,
    bk.book_name,
    b.borrow_date
FROM Borrow b
INNER JOIN members_name m ON b.member_id = m.member_id
INNER JOIN Book bk ON b.book_id = bk.book_id;

-- left join
SELECT
    bk.book_id,
    bk.book_name,
    rb.return_book_name,
    rb.return_date,
    rb.fine_expands
FROM Book bk
LEFT JOIN return_book rb ON bk.book_name = rb.return_book_name;

-- right join
SELECT
    b.borrow_id,
    b.book_id,
    b.borrow_date,
    m.member_id,
    m.name AS member_name
FROM Borrow b
RIGHT JOIN members_name m ON b.member_id = m.member_id;

-- full join
SELECT
    bk.book_id,
    bk.book_name,
    rb.return_book_name,
    rb.return_date,
    rb.fine_expands
FROM Book bk
LEFT JOIN return_book rb ON bk.book_name = rb.return_book_name
UNION
SELECT
    bk.book_id,
    bk.book_name,
    rb.return_book_name,
    rb.return_date,
    rb.fine_expands
FROM Book bk
RIGHT JOIN return_book rb ON bk.book_name = rb.return_book_name;

-- scalar subquery in select :

SELECT
    b.book_id,
    b.book_name,
    (
        SELECT COUNT(*)
        FROM Borrow br
        WHERE br.book_id = b.book_id
    ) AS borrow_count
FROM Book b;

-- Subquery in WHERE with IN

SELECT *
FROM members_name
WHERE member_id IN (
    SELECT DISTINCT member_id
    FROM Borrow
);

--  Subquery in WHERE with EXISTS

SELECT *
FROM Book bk
WHERE EXISTS (
    SELECT 1
    FROM Borrow b
    WHERE b.book_id = bk.book_id
);

-- Correlated Subquery in WHERE

SELECT *
FROM Borrow b1
WHERE borrow_date = (
    SELECT MIN(b2.borrow_date)
    FROM Borrow b2
    WHERE b2.member_id = b1.member_id
);

-- Subquery in FROM

SELECT
    rb.return_book_name,
    rb.total_fine
FROM (
    SELECT
        return_book_name,
        AVG(fine_expands) AS total_fine
    FROM return_book
    GROUP BY return_book_name
) rb;

--  Subquery with comparison operator =

SELECT *
FROM members_name m
WHERE (
    SELECT COUNT(*)
    FROM Borrow b
    WHERE b.member_id = m.member_id
) = (
    SELECT COUNT(*)
    FROM Borrow
    WHERE member_id = 1
);

-- Subquery with NOT EXISTS

SELECT *
FROM Book bk
WHERE NOT EXISTS (
    SELECT 1
    FROM Borrow b
    WHERE b.book_id = bk.book_id
);


-- views: Show all borrow records with member names and book names

CREATE VIEW view_borrow_details AS
SELECT
    b.borrow_id,
    m.name AS member_name,
    bk.book_name,
    b.borrow_date
FROM Borrow b
INNER JOIN members_name m ON b.member_id = m.member_id
INNER JOIN Book bk ON b.book_id = bk.book_id;

SELECT * FROM view_borrow_details;

-- View: Members with their total borrow counts
CREATE VIEW view_member_borrow_count AS
SELECT
    m.member_id,
    m.name,
    COUNT(b.borrow_id) AS total_borrowed
FROM members_name m
LEFT JOIN Borrow b ON m.member_id = b.member_id
GROUP BY m.member_id, m.name;

-- Usage example: Who borrowed more than 1 book
SELECT *
FROM view_member_borrow_count
WHERE total_borrowed > 1;


-- View: Books and their availability status
CREATE VIEW view_book_availability AS
SELECT
    book_id,
    book_name,
    gener,
    available_num,
    CASE
        WHEN available_num > 0 THEN 'Available'
        ELSE 'Not Available'
    END AS availability_status
FROM Book;

-- Usage example
SELECT * FROM view_book_availability
ORDER BY book_name;

-- View: Return book details with fines above 0
CREATE VIEW view_fines_only AS
SELECT
    return_book_id,
    return_book_name,
    return_date,
    fine_expands
FROM return_book
WHERE fine_expands > 0;

-- Usage example
SELECT * FROM view_fines_only;


-- View: Simplified member contact list (for security: no joins, no borrowing info)
CREATE VIEW view_member_contacts AS
SELECT
    member_id,
    name,
    email,
    contact_no
FROM members_name;

-- Usage example
SELECT * FROM view_member_contacts;
