create database library;
use library;

DROP TABLE IF EXISTS return_book;
DROP TABLE IF EXISTS Borrow;
DROP TABLE IF EXISTS Book;
DROP TABLE IF EXISTS members_name;

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

select * from members_name;
SELECT * FROM Book;
SELECT * FROM Borrow;
SELECT * FROM return_book;


-- Entities and Relationships
--  What is an Entity?
 -- entity represents a thing or object in the domain. It becomes a table in the database.

-- What is a Relationship?
-- A relationship shows how two entities are connected

-- Entity       | Description                               
-- Customer     | A person who purchases products           
-- Product      | An item available for sale                
--  Order       | A purchase made by a customer             
-- Order\_Item  | Each product in an order (many per order) 
-- Payment      | Payment details for an order              
