use master

-- create the Peer Review DB
Create database Peer_Review
Go

use Peer_Review
Go

-- COURSE TABLE
create table COURSE(
	CRS_CODE varchar(10) PRIMARY KEY,
	CRS_TITLE varchar(100) not null,
	CRS_CREDITS int	not null
)

-- CLASS TABLE
create table CLASS(
	CLA_CRN char(5) PRIMARY KEY, 
	CRS_CODE varchar(10) REFERENCES COURSE(CRS_CODE) not null, 
	CLA_HAS_PROJECT bit default(0),
	CLA_PROJ_GRADE int check(CLA_PROJ_GRADE > 0 AND CLA_PROJ_GRADE <= 50) default(0)
)

-- STUDENT TABLE 
create table STUDENT(
	STU_NUM	char(9) PRIMARY KEY, 
	STU_NAME varchar(50) not null
)

-- CLASS_GROUP TABLE
create table CLASS_GROUP(
	GRP_ID int PRIMARY KEY,
	CLA_CRN char(5) REFERENCES CLASS(CLA_CRN) not null, 
	GRP_NUM int not null
)

-- REGISTERED_STUDENT TABLE
create table REGISTERED_STUDENT(
	CLA_CRN char(5) not null REFERENCES CLASS(CLA_CRN),
	STU_NUM char(9) not null REFERENCES STUDENT(STU_NUM), 
	GRP_ID int REFERENCES CLASS_GROUP(GRP_ID)
	CONSTRAINT PK_REGISTERED_STUDENT PRIMARY KEY(CLA_CRN, STU_NUM)
)

-- Adding COURSE Data
INSERT INTO COURSE VALUES('COMP 1630', 'Relational Database Design and SQL', 5)

-- Adding all COMP 1630 classes 
INSERT INTO CLASS VALUES('59125', 'COMP 1630', 1, 20)
INSERT INTO CLASS VALUES('57598', 'COMP 1630', 1, 20)
INSERT INTO CLASS VALUES('57599', 'COMP 1630', 1, 20)

-- adding some students
INSERT INTO STUDENT VALUES(1, 'Alyssa Aniks')
INSERT INTO STUDENT VALUES(2, 'Kyle Briggs')
INSERT INTO STUDENT VALUES(3, 'Jianfen Deng')
INSERT INTO STUDENT VALUES(4, 'Ahmed Hassan')
INSERT INTO STUDENT VALUES(5, 'Silvana Kalliny')
INSERT INTO STUDENT VALUES(6, 'Sehajpreet Kingara')
INSERT INTO STUDENT VALUES(7, 'Erick Lee')
INSERT INTO STUDENT VALUES(8, 'Sepehr Mansouri')
INSERT INTO STUDENT VALUES(9, 'Jalal Mirahmadi')
INSERT INTO STUDENT VALUES(10, 'Joban Nijjer')
INSERT INTO STUDENT VALUES(11, 'Abram Quinton')
INSERT INTO STUDENT VALUES(12, 'Moh Saify')
INSERT INTO STUDENT VALUES(13, 'Samuel Shannon')
INSERT INTO STUDENT VALUES(14, 'Shahriar Shayesteh')
INSERT INTO STUDENT VALUES(15, 'Harsimran Singh')
INSERT INTO STUDENT VALUES(16, 'He Chen Song')
INSERT INTO STUDENT VALUES(17, 'Ting Yu Song')
INSERT INTO STUDENT VALUES(18, 'Shao Juan')
INSERT INTO STUDENT VALUES(19, 'John Smith')

-- forming groups
INSERT INTO CLASS_GROUP VALUES(1, '59125', 1)
INSERT INTO CLASS_GROUP VALUES(2, '59125', 2)
INSERT INTO CLASS_GROUP VALUES(3, '59125', 3)
INSERT INTO CLASS_GROUP VALUES(4, '59125', 4)

INSERT INTO CLASS_GROUP VALUES(5, '57598', 1)
INSERT INTO CLASS_GROUP VALUES(6, '57598', 2)
INSERT INTO CLASS_GROUP VALUES(7, '57598', 3)
INSERT INTO CLASS_GROUP VALUES(8, '57598', 4)

-- Registering students to their classes
INSERT INTO REGISTERED_STUDENT VALUES('59125', 3, 1)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 6, 1)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 11, 1)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 17, 1)

INSERT INTO REGISTERED_STUDENT VALUES('59125', 2, 2)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 10, 2)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 14, 2)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 16, 2)

INSERT INTO REGISTERED_STUDENT VALUES('59125', 1, 3)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 5, 3)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 9, 3)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 12, 3)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 18, 3)

INSERT INTO REGISTERED_STUDENT VALUES('59125', 4, 4)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 7, 4)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 8, 4)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 13, 4)
INSERT INTO REGISTERED_STUDENT VALUES('59125', 15, 4)

INSERT INTO REGISTERED_STUDENT VALUES('57598', 19, 1)

---------------------------------------------------------------------------- 
-- QUESTION 1
-- 
-- Using a CREATE TABLE statement, implement the STUDENT_REVIEW table.
-- Your table should:
---- 1- include all attributes in the ERD
---- 2- have a PK
---- 3- have all FKs implemented
---- 4- ensure the values of  CONTRIBUTIONS, PRESENCE, TEAM_SKILLS, and COMMUNICATION 
----	are one of 'EXCELLENT', 'POOR' or 'ACCEPTABLE'
---- 5- use not null constraint when required
---- 6- use a default date for a new review 
----------------------------------------------------------------------------
create table STUDENT_REVIEW (
	REV_ID char(5),
	CONTRIBUTIONS varchar(10) NOT NULL,
	PRESENCE varchar(10) NOT NULL,
	TEAM_SKILLS varchar(10) NOT NULL,
	COMMUNICATION varchar(10) NOT NULL,
	REV_DATE DATE default GETDATE(),
	CLA_CRN char(5) not null,
	REVIEWER_ID char(9) not null,
	STU_NUM	char(9) not null REFERENCES STUDENT(STU_NUM),
	CONSTRAINT REVIEWER_ID FOREIGN KEY (CLA_CRN, REVIEWER_ID) REFERENCES REGISTERED_STUDENT(CLA_CRN, STU_NUM),
	PRIMARY KEY(REV_ID),
	CONSTRAINT chk_CONTRIBUTIONS CHECK(CONTRIBUTIONS IN ('EXCELLENT', 'POOR','ACCEPTABLE')),
	CONSTRAINT chk_PRESENCE CHECK(PRESENCE IN ('EXCELLENT', 'POOR','ACCEPTABLE')),
	CONSTRAINT chk_TEAM_SKILLS CHECK(TEAM_SKILLS IN ('EXCELLENT', 'POOR','ACCEPTABLE')),
	CONSTRAINT chk_COMMUNICATION CHECK(COMMUNICATION IN ('EXCELLENT', 'POOR','ACCEPTABLE')),
);

---------------------------------------------------------------------------- 
-- QUESTION 2
-- 
-- Write a SELECT query to answer the following question: 
---- How many classes are offering COMP 1630 course?
----------------------------------------------------------------------------
SELECT COUNT(CRS_CODE) AS Number_of_COMP_1630_Classes
FROM CLASS




---------------------------------------------------------------------------- 
-- QUESTION 3
-- 
-- Write a SELECT query to answer the following question: 
---- How many students are registered in each class? 
----------------------------------------------------------------------------
SELECT CLA_CRN, COUNT(STU_NUM) AS NUMBER_OF_STUDENTS
FROM REGISTERED_STUDENT
GROUP BY (CLA_CRN);


-- dont see 57599 in database
---------------------------------------------------------------------------- 
-- QUESTION 4
-- 
-- Write a SELECT query to answer the following question: 
---- What is the PK of the group John Smith belongs to? 
----------------------------------------------------------------------------

SELECT * 
FROM STUDENT
JOIN REGISTERED_STUDENT on REGISTERED_STUDENT.STU_NUM = STUDENT.STU_NUM
WHERE STUDENT.STU_NAME = 'John Smith'



---------------------------------------------------------------------------- 
-- QUESTION 5
-- 
-- Write a SELECT query to answer the following question: 
---- Who are Joban's group-mates in COMP 1630?
----------------------------------------------------------------------------
SELECT CLA_CRN, REGISTERED_STUDENT.STU_NUM
FROM REGISTERED_STUDENT
join STUDENT on STUDENT.STU_NUM = REGISTERED_STUDENT.STU_NUM
WHERE GRP_ID in (
	SELECT GRP_ID
	FROM REGISTERED_STUDENT
	where STU_NUM in (
		SELECT STU_NUM 
		FROM STUDENT
		WHERE STU_NAME = 'Joban Nijjer'
	)
)



---------------------------------------------------------------------------- 
-- QUESTION 6
-- 
-- Execute the following code. 
-- Using SQL comments below these instruction, explain in proper terms what 
-- the following code does and why it is needed:
---
---
---
---
---
---
----------------------------------------------------------------------------

GO
Create or alter trigger trg_review_check
on Student_REVIEW
INSTEAD of INSERT
as
	DECLARE @REVIEWER_GROUP int;
	SET @REVIEWER_GROUP = (SELECT GRP_ID 
				FROM REGISTERED_STUDENT JOIN INSERTED
				ON INSERTED.CLA_CRN = REGISTERED_STUDENT.CLA_CRN
				AND INSERTED.REVIEWER_ID = REGISTERED_STUDENT.STU_NUM)
	IF EXISTS(SELECT * 
			FROM REGISTERED_STUDENT 
			JOIN INSERTED ON 
				INSERTED.CLA_CRN = REGISTERED_STUDENT.CLA_CRN
				AND INSERTED.STU_NUM = REGISTERED_STUDENT.STU_NUM
				AND GRP_ID = @REVIEWER_GROUP)
		INSERT INTO STUDENT_REVIEW Select * from inserted;
	ELSE
		RAISERROR('two students should be in the same group', 1, 1);
		RETURN
		-- creates a trigger  trg_review_check that checks if the two students that are particpating in the review are from the same group,
		-- if it passes it allows the insert to execute or else it raises an error, it is nessacery because there is no constraint for this otherwise
		
---------------------------------------------------------------------------- 
-- QUESTION 7
--  assume you are one of the existing students. 
--  using SQL INSERT statements, write a review for each of your teammates 
--  as well as one review for yourself.
---------------------------------------------------------------------------- 

Insert INTO STUDENT_REVIEW (REV_ID, CONTRIBUTIONS, PRESENCE, TEAM_SKILLS, COMMUNICATION, CLA_CRN, REVIEWER_ID, STU_NUM)
VALUES(001, 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 59125, 10, 10)

Insert INTO STUDENT_REVIEW (REV_ID, CONTRIBUTIONS, PRESENCE, TEAM_SKILLS, COMMUNICATION, CLA_CRN, REVIEWER_ID, STU_NUM)
VALUES(002, 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 59125, 10, 14)

Insert INTO STUDENT_REVIEW (REV_ID, CONTRIBUTIONS, PRESENCE, TEAM_SKILLS, COMMUNICATION, CLA_CRN, REVIEWER_ID, STU_NUM)
VALUES(003, 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 59125, 10, 16)

Insert INTO STUDENT_REVIEW (REV_ID, CONTRIBUTIONS, PRESENCE, TEAM_SKILLS, COMMUNICATION, CLA_CRN, REVIEWER_ID, STU_NUM)
VALUES(004, 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 59125, 10, 2)

---------------------------------------------------------------------------- 
-- QUESTION 8
-- 
-- Write a SELECT query to generate a list of reviews you have received so far
----------------------------------------------------------------------------
SELECT * 
FROM STUDENT_REVIEW
WHERE STU_NUM = '10'



---------------------------------------------------------------------------- 
-- QUESTION 9
-- 
-- Write a SELECT query to generate a list of reviews you have written so far
---------------------------------------------------------------------------- 
SELECT * 
FROM STUDENT_REVIEW
WHERE REVIEWER_ID = '10'


---------------------------------------------------------------------------- 
-- QUESTION 10
-- 
-- write a review for a student not in your team. 
-- what happens? Does the review record get saved in the DB? Why or Why not?
---
--- The record does not get saved because of the trigger created in question 6
---
---
---
---------------------------------------------------------------------------- 


Insert INTO STUDENT_REVIEW (REV_ID, CONTRIBUTIONS, PRESENCE, TEAM_SKILLS, COMMUNICATION, CLA_CRN, REVIEWER_ID, STU_NUM)
VALUES(004, 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 'EXCELLENT', 59125, 10, 3)


---------------------------------------------------------------------------- 
-- QUESTION 11
-- Create an index to make sure that at any given date, 
-- each student can only review another student in their group once.
---------------------------------------------------------------------------

CREATE Unique Index STUDENT_CAN_ONLY_REVIEW_ONCE
on STUDENT_REVIEW (REVIEWER_ID, STU_NUM, REV_DATE)