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
