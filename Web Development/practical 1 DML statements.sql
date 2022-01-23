create database sample;
use sample;
create table student(
	roll_no int not null,
    std_name varchar(50),
    course varchar(20),
    city varchar(20),
    fees decimal(10,2),
    primary key(roll_no)
);

desc student;

insert into student values(1,'Jennifer','Ansiton','pune',2000 );
insert into student values(2,'Charlie','Sheen','mumbai',3000 );
insert into student values(3,'Matt','Damon','delhi',1500 );
insert into student values(4,'Jennifer','Lopez','ban', 2500);


select *from student;

Delimiter //
create trigger before_insert_fees BEFORE INSERT on student for each row
begin
if new.fees > 5000 then 
set new.fees = 35000;
end if;
end //

insert into student values(5,'xy','ab','abcn', 5001);

	
    
    
    
    
    
    
    

    
create database student_info;
use student_info;

create table student_detail(
s_id int not null,
s_enroll int not null,
s_fname varchar(20),
s_lname varchar(20),
s_contact int(10),
s_city varchar(20),
s_department varchar(30),
primary key(s_id)
);

create table student_marks(
s_id int not null,
r_id int not null,
s_enroll int not null,
r_sub1Marks int,
r_sub2Marks int,
r_sub3Marks int,
primary key(r_id)

);

desc student_detail;

desc student_marks;

# Insert query type 1
insert into student_detail(s_id, s_enroll, s_fname, s_lname, s_contact, s_city, s_department)
	   values(1, 101 , 'Fawzaan', 'shaik' , 123123 , 'pune' , 'cse');
       
# insert query type 2
insert into student_detail values(2, 102, 'Pushkar', 'Narkhede' , 23235656, 'jalgaon' , 'cse');
insert into student_detail values(3, 103, 'Achal', 'Mate' , 12456523, 'nagar' , 'cse');
insert into student_detail values(4, 104, 'Anusharee', 'gund' , 12589635, 'pune' , 'cse');
insert into student_detail values(5, 105, 'Himanshu', 'gupta' , 54236987, 'pune' , 'ns');
insert into student_detail values(6, 106, 'sohan', 'bhole' , 98562147, 'jalgaon' , 'core');
insert into student_detail values(7, 107, 'nikhil', 'harpale' , 45632178, 'pune' , 'ns');
insert into student_detail values(8, 108, 'shubangi', 'bhorker' , 25478963, 'naskik' , 'core');

select *from student_detail;





insert into student_marks values(1, 001, 101, 98,95,96);
insert into student_marks values(2, 002, 102, 98,78,89);
insert into student_marks values(3, 003, 103, 75,68,82);
insert into student_marks values(4, 004, 104, 98,86,79);
insert into student_marks values(5, 005, 105, 82,83,84);
insert into student_marks values(6, 006, 106, 99,65,75);
insert into student_marks values(7, 007, 107, 75,93,83);
insert into student_marks values(8, 008, 108, 76,87,91);


select * from student_marks;

#truncate student_marks;
#truncate student_detail;


update student_detail set s_contact = 12345678 where s_id = 1;
select *from student_detail where s_id = 1;

delete from student_detail where s_enroll= 104;
delete from student_marks where s_enroll = 104;

grant delete on student_detail to root;
revoke delete on student_detail from root;

#drop database student_info;

#saving all tracntion
savepoint save_detail;

#commitng all tanscation
commit;

#rollbaking transcation
rollback;

select *from student_detail;


#join operation
# cross join
select *from student_detail cross join student_marks;

select *from student_detail inner join student_marks where student_detail.s_id = student_marks.s_id;

select *from student_detail left outer join  student_marks on student_detail.s_id = student_marks.s_id;

select *from student_detail Right outer join  student_marks on student_detail.s_id = student_marks.s_id;

select *from student_detail left outer join student_marks on student_detail.s_id = student_marks.s_id
union
select *from student_detail Right outer join  student_marks on student_detail.s_id = student_marks.s_id;

select * from student_marks



select *from student_detail where s_id  in (select s_id from student_marks where r_sub1Marks < 80)





# stord procedure in paramtaer
call max_marks(90);
call student_detail_per_input('jalgaon' , 'cse') ;

call student_sort_per_marks(80,80,80);
call min_marks_sub1

select *from student_detail where s_id in (select s_id from student_marks where r_sub1Marks = (select min(r_sub1Marks) from student_marks))


#out paramater
call avg_marks(@marks);
select @marks 'Subject1 Avg marks';	

select avg(r_sub1Marks) from student_marks where s_id in (select s_id from student_detail where s_department = 'cse')

#inout
set @roll = 102;
call avg_marks(@roll);
select @roll as subject1_marks;

select s_department 'Department Name', count(s_department) 'No of Student' from student_detail group by s_department;

#procedure without param
call dept_wise_studentCount;


select s_id 'ID' , s_enroll 'Enrollment no', r_sub1Marks 'subject1 Mark', calculate(r_sub1Marks) 'Subject 1 Grade', 
r_sub2Marks 'subject2 Mark', calculate(r_sub2Marks) 'Subject 2 Grade',
r_sub3Marks 'subject3 Mark' , calculate(r_sub3Marks) 'Subject 3 Grade' from student_marks;

select s_id 'ID' , s_enroll 'Enrollment', r_sub1Marks 'Sub1 Marks', r_sub2Marks 'Sub2 Marks',
 r_sub3Marks 'Sub3 Marks', calculate_total(r_sub1Marks, r_sub2Marks, r_sub3Marks) 'Total marks' from student_marks;
 
select s_id 'ID', s_enroll 'Enrollment', r_sub1Marks 'Sub1 Marks', r_sub2Marks 'Sub1 Marks', r_sub3Marks 'Sub1 Marks',
calculate_total(r_sub1Marks, r_sub2Marks, r_sub3Marks) 'Total marks', 
calculate_percent(calculate_total(r_sub1Marks, r_sub2Marks, r_sub3Marks)) 'Percentage',
calculate(calculate_percent(calculate_total(r_sub1Marks, r_sub2Marks, r_sub3Marks))) 'Grade'calculatecalculate
from student_marks;

#functions agg
select count(s_id) 'Student Count' from student_detail;
select max(r_sub1Marks) 'Sub1 max Marks', max(r_sub2Marks) 'Sub1 max Marks', max(r_sub3Marks)'Sub1 max Marks' from student_marks;
select min(r_sub1Marks) 'Sub1 min Marks', min(r_sub2Marks) 'Sub1 min Marks', min(r_sub3Marks)'Sub1 min Marks' from student_marks;
select round(avg(r_sub1Marks),2) 'Sub1 avg Marks',round(avg(r_sub2Marks),2) 'Sub1 avg Marks', round(avg(r_sub3Marks),2)'Sub1 avg Marks' from student_marks;

#function scalar
select ucase(s_fname) 'First Name' , ucase(s_lname)'Last Name' from student_detail;
 




# trigger

DELIMITER $$
CREATE TRIGGER restrict_insert BEFORE INSERT on student_marks FOR EACH ROW
BEGIN
 IF new.r_sub1Marks >100 or new.r_sub2Marks >100 or new.r_sub3Marks >100 THEN 
  SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Subject marks can''t be more than 100';
    END IF;
END$$

#drop trigger restrict_insert;

select *from student_marks;
insert into student_marks values(55, 009, 109, 95,105,96);


# trigegr after insert
CREATE TABLE student_mark_detail(
total_marks int NOT NULL,
percent float,
grade varchar(2)
);

#drop table student_mark_detail;
describe student_mark_detail;

DELIMITER $$
CREATE TRIGGER insert_ttl_percent AFTER INSERT on student_marks FOR EACH ROW
BEGIN
 SET @total = new.r_sub1Marks + new.r_sub1Marks + new.r_sub1Marks ;
 SET @percent = round(@total / 3 , 2);
 SET @grade = 'NA';
 if @percent > 90 then set @grade = 'A';
 elseif @percent >80 and @percent <=90 then set @grade = 'B';
 elseif @percent >70 and @percent <=90 then set @grade = 'C';
 end if;
 insert into student_mark_detail values(@total , @percent, @grade);
END$$

#drop trigger insert_ttl_percent;

select *from student_marks;
insert into student_marks values(88, 88, 88, 70,85,85);

select *from student_mark_detail;



# trigger update
DELIMITER $$
CREATE TRIGGER restrict_update BEFORE UPDATE on student_marks FOR EACH ROW
BEGIN
 IF new.r_sub1Marks >100 or new.r_sub2Marks >100 or new.r_sub3Marks >100 THEN 
  SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'Subject marks can''t be more than 100 enter marks in range of 0 to 100';
    END IF;
END$$

#drop trigger restrict_update;

update student_marks set r_sub1Marks = 105 where s_id = 3;
select *from student_marks;

Create table staff(
staff_id int not null primary key,
staff_name varchar(80),
staff_dept varchar(30),
staff_salary float,
staff_domain varchar(30)
);

CREATE TABLE staff_log_table(
satff_id int,
staff_dept varchar(30),
staff_salary float,
staff_domain varchar(30)
);



insert into staff values(111, 'Seema Ghorsad', 'CSE', 11000,'DBMS');
insert into staff values(222, 'Rashmi Nair', 'CSE', 12000,'DL');
insert into staff values(333, 'Swati Dhopte', 'CSE', 13000,'DS');
insert into staff values(444, 'Swati Shirke', 'CSE', 14000,'AI');
insert into staff values(555, 'Sweet Shubshree', 'CSE', 15000,'OS');

select *from staff;

DELIMITER $$
CREATE TRIGGER log_afterUpdate AFTER UPDATE on staff FOR EACH ROW
BEGIN

 SET @staff_dept = old.staff_dept;
  SET @staff_id = old.staff_id;
   SET @satff_sal = old.staff_salary;
    SET @satff_domain = old.staff_domain;
    
    insert into staff_log_table values(@staff_id,@staff_dept,@satff_sal,@satff_domain);
 
END$$

update staff set staff_salary = 64000 where staff_id =333;

select *from staff;
select *from  staff_log_table;


#trigegr before delete 
alter table staff add staff_status varchar(10);
describe staff;

update staff set staff_status = 'Permenente' where staff_id = 111;
update staff set staff_status = 'Permenente' where staff_id = 222;
update staff set staff_status = 'Permenente' where staff_id = 333;
update staff set staff_status = 'Permenente' where staff_id = 444;
update staff set staff_status = 'Temporary' where staff_id = 555;

select *from staff;

DELIMITER $$
CREATE TRIGGER restrict_delete BEFORE DELETE on staff FOR EACH ROW
BEGIN
  IF old.staff_status = 'Permenente' THEN 
  SIGNAL SQLSTATE '02000' SET MESSAGE_TEXT = 'You are not authorized to delete Permenente staff data';
    END IF;
END$$

delete from staff where staff_status = 'Permenente';

create table cursor_tbl(
s_id int,
enroll int,
fName varchar(30),
lName varchar(30),
dept varchar(30),
sub1 int,
sub2 int,
sub3 int,
total int,
percent float,
grade varchar(3)
);


describe cursor_tbl;

call demo_cursor;

select *from cursor_tbl;
use student_info;
select *from student_marks;

select max(r_sub1Marks) "Average ofSubject 1 Marks " from student_marks;








==============================================================

create database sohanDemo;
use sohanDemo;

create table sonu(Rollno int, Fname varchar(20), Class varchar(3), Marks int);
desc sonu;
drop table sonu;

Insert into sonu(Rollno, fname, Class, Marks) values(50, "Sohan", "Cse", 75);
select * from sonu;

Insert into sonu(Rollno, fname, Class, Marks) values(51, "Pussy", "Cse", 55);
Insert into sonu(Rollno, fname, Class, Marks) values(52, "Rohan", "Cse", 56);
select * from sonu

Insert into sonu(Rollno, fname, Class, Marks) values(45, "Shubhm", "Cse", 80);
Insert into sonu(Rollno, fname, Class, Marks) values(60, "Eshan", "Cse", 86);

update sonu set Class = "IS" where Rollno = 45;

Insert into sonu(Rollno, fname, Class, Marks) values(51, "Pussy", "Cse", 55);
update sonu set Class = "NS" where Rollno = 51;

update sonu set Fname = "Puskya" where Rollno = 60;

update sonu set Marks = 98 where Fname = "Pussy";

delete from sonu where Rollno = 51;

delete from sonu where Fname = "Pussy";

delete from sonu where Rollno = 45;
delete from sonu where Rollno = 60;

select *from sonu
select max(Marks) from sonu

select *from sonu where Rollno in ( select Rollno from sonu where fname = "Sohan")

























create database sample;
use sample;
create table student(
		roll_no int not null,
        std_name varchar(50),
        course varchar(20),
        city varchar(20),
        fees deimal (10,2),
        primary key (roll_no)
);    sonu    















create database userLogin;
use userLogin;

create table userInfo(uid varchar(30) primary key not null, pass varchar(30) not null);
desc userInfo;



insert into userInfo (uid,pass) values("root", "root");
insert into userInfo (uid,pass) values("push", "push@");
insert into userInfo (uid,pass) values("pushkarnarkhede01@gmail.com", "pushkar@");
select *from userInfo;


create table resgiterUser(fname varchar(20), lname varchar(20), contact varchar(30), age int , gender varchar(10), bg varchar(5), city varchar(30),
email varchar(30) not null primary key);

desc resgiterUser;

insert into resgiterUser(fname, lname, contact, age, gender, bg, city, email) values("Pushkar" ,"Narkhede", 9284236136, 21,"male", "B+", "Pune", "pushkarnarkhede01@gmail.com")

select fname,lname from resgiterUser where email = "pushkarnarkhede01@gmail.com";

create table covid(email varchar(30) not null ,fever varchar(5), cough varchar(5), breathing varchar(5), head varchar(5), sore varchar(5), result varchar(200));

insert into covid values("achal@gmail.com", "yes", "yes", "yes", "yes", "yes", "Positive")
alter table covid add column testDate date;

select *from covid



create table breast(email varchar(30) not null ,tm float, cm float, sm float, ts float, ase float, fd float, result varchar(200), testDate date);
insert into breast(email,tm,cm,sm,ts,ase,fd,result,testDate) values("pushkarnarkhede01@gmail.com",12.5,32.5,55.2,25.01,0.12,0.25,"positive", "2021-12-09")

select *from breast