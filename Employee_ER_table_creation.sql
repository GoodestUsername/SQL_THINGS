select * from sys.databases
use MASTER;
go
IF DB_ID (N'THREE_STRIKES_CASINO_DB') IS NOT NULL
DROP DATABASE THREE_STRIKES_CASINO_EMPLOYEE_DB;
go
CREATE DATABASE THREE_STRIKES_CASINO_EMPLOYEE_DB;
go

SELECT name, size, size*1.0/128 AS [SIZE in MBs]
FROM sys.master_files
WHERE name = N'THREE_STRIKES_CASINOO_EMPLOYEE_DB';
go


select * from sys.databases
use THREE_STRIKES_CASINO_EMPLOYEE_DB;
CREATE TABLE DEPARTMENT (
DEPT_ID					INTEGER			 NOT NULL UNIQUE,
DEPT_NAME				VARCHAR(40)		 NOT NULL,
DEPT_LOCATION				VARCHAR(100)	 NOT NULL,
PRIMARY KEY(DEPT_ID)
);

CREATE TABLE EMPLOYEE (
EMP_ID					INTEGER			 NOT NULL UNIQUE,
DEPT_ID				INTEGER,
EMP_FIRST_NAME				VARCHAR(40)		 NOT NULL,
EMP_LAST_NAME				VARCHAR(40)		 NOT NULL,
EMP_TITLE				VARCHAR(40),
EMP_HIRE_DATE				DATE		 NOT NULL,
EMP_IS_VACTION_ELIGIBLE			BIT				 NOT NULL,
EMP_IS_ACTIVE				BIT				 NOT NULL,
PRIMARY KEY (EMP_ID),
FOREIGN KEY(DEPT_ID) REFERENCES DEPARTMENT(DEPT_ID)
);
CREATE TABLE UNIFORM (
UNIFORM_ID					INTEGER			NOT NULL UNIQUE,
EMP_ID						INTEGER,
UNIFORM_SIZE					INTEGER, CONSTRAINT SIZE CHECK (UNIFORM_SIZE>=10 AND UNIFORM_SIZE<=18),
PRIMARY KEY (UNIFORM_ID),
FOREIGN KEY(EMP_ID) REFERENCES DEPARTMENT
);

