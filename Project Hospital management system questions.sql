-- =========================
-- SQL Case Study: Hospital Management System
-- =========================
create database Hospital_Management_System;
use Hospital_Management_System;
-- ========= DDL Section =========

-- Q1: Design a table named `Patients` to store details of each patient admitted to the 
-- hospital. 
-- Include the following fields:
-- - `patient_id` (unique integer identifier for each patient),
-- - `name` (name of the patient),
-- - `gender` (gender of the patient as a string),
-- - `dob` (date of birth),
-- - `admission_date` (the date on which the patient was admitted).
-- Ensure that `patient_id` is the Primary Key.
create table patients(
patient_id int primary key auto_increment,
name varchar(50),
gender enum("M","F"),
dob date,
admission_date date)auto_increment=201;

-- Q2: Create a table named `Doctors` to store records of doctors working in the hospital.
-- The table should include:
-- - `doctor_id` (a unique identifier for each doctor),
-- - `name` (doctor's full name),
-- - `specialty` (the medical specialization of the doctor),
-- - `joining_date` (the date the doctor joined the hospital).
-- Make `doctor_id` the Primary Key for the table.
create table doctors(
doc_id int primary key unique not null,
name varchar(50),
speciality varchar(20),
joining_date date)auto_increment=101;

-- Q3: Create a table called `Appointments` to manage scheduling between patients and doctors.
-- Each record should store:
-- - `appointment_id` (a unique appointment identifier),
-- - `patient_id` (ID of the patient who booked the appointment),
-- - `doctor_id` (ID of the doctor the appointment is with),
-- - `appointment_date` (date of the appointment),
-- - `diagnosis` (brief notes about the diagnosis).
-- Ensure `patient_id` and `doctor_id` are linked as Foreign Keys to the respective tables.
create table appointments(
app_id int primary key,
patient_id int,
doc_id int,
appointment_date date,
diagnosis varchar(50),
foreign key(patient_id) references patients(patient_id),
foreign key(doc_id) references doctors(doc_id));

Alter table appointments auto_increment=1001;

-- Q4: Design a table named `Bills` to manage billing information for each patient.
-- Include the following columns:
-- - `bill_id` (unique bill number),
-- - `patient_id` (linked to the patient receiving the bill),
-- - `total_amount` (total amount to be paid),
-- - `paid` (boolean indicating whether the bill has been paid),
-- - `payment_date` (date of payment if applicable).
-- Use `patient_id` as a Foreign Key referencing the `Patients` table.
create table bills(
bill_id int unique primary key not null,
patient_id int,
total_amount int,
paid int,
payment_date date,
foreign key(patient_id) references patients(patient_id))auto_increment=1;

Alter table patients auto_increment=1;
Alter table doctors auto_increment=101;
Alter table bills auto_increment=201;

-- ========= DML Section (Predefined) =========
INSERT INTO Patients(name,gender, dob, admission_date) VALUES
('Ravi Kumar', 'M', '1990-05-12', '2024-04-01'),
('Anita Sharma', 'F', '1985-08-25', '2024-04-03'),
('Imran Ali', 'M', '1978-03-14', '2024-04-05');

INSERT INTO Doctors(name, speciality, joining_date) VALUES
('Dr. Neha Verma', 'Cardiologist', '2020-01-15'),
('Dr. Rajeev Menon', 'Surgeon', '2018-06-10'),
('Dr. Alok Das', 'Dermatologist', '2021-11-22');

INSERT INTO Appointments (patient_id, doc_id, appointment_date, diagnosis) VALUES
(1, 101, '2024-04-01', 'High BP'),
(2, 102, '2024-04-03', 'Appendicitis'),
(3, 103, '2024-04-06', 'Skin Allergy');

INSERT INTO Bills(patient_id, total_amount, paid, payment_date) VALUES
(1, 2500.00, 1, '2024-04-02'),
(2, 4000.00, 0, NULL),
(3, 1500.00, 1, '2024-04-07');

select * from appointments;
select * from bills;
select * from doctors;
select * from patients;
-- ========= DQL, Joins, Group By, Aggregate Practice =========

-- Q5: Retrieve all patients in the hospital.
select patient_id, name from patients;

-- Q6: List all doctors who joined after the year 2020.
select doc_id, name, joining_date from doctors where year(joining_date)>2020;

-- Q7: Find all appointments for a patient named Ravi Kumar.
select a.app_id,p.patient_id,p.name from appointments a left join patients p on a.patient_id=p.patient_id where p.name="Ravi Kumar";

-- Q8: List doctor names who treated more than one patient.
select d.name, count(a.patient_id) from doctors d left join appointments a on d.doc_id=a.doc_id group by d.name having count(a.patient_id)>1;

-- Q9: Retrieve all unpaid bills.
select * from bills where paid=0;

-- Q10: Calculate the average bill amount.
select avg(total_amount) from bills;

-- Q11: Show total amount paid by each patient who completed the payment.
select bill_id, total_amount, paid from bills where paid!=0;

-- Q12: Display all patients with their corresponding doctor names.
select p.name,d.name from patients p left join appointments a on p.patient_id=a.patient_id inner join doctors d on d.doc_id=a.doc_id;

-- Q13: Identify departments with more than one doctor.
select speciality from doctors group by speciality having count(doc_id)>1;

-- Q14: Count the number of appointments for each doctor.
select doc_id, count(app_id) from appointments group by doc_id;

-- Q15: List names of patients who had appointments after April 2, 2024.
select p.name, a.patient_id, a.appointment_date from patients p left join appointments a on p.patient_id=a.patient_id where a.appointment_date>"2024-04-02";

-- Q16: Show all appointments along with whether the bill has been paid.
select a.app_id, a.patient_id, b.paid from appointments a left join bills b on a.patient_id=b.patient_id;

-- Q17: Retrieve names and bill amounts of patients who have completed payment.
select p.name, b.total_amount from patients p inner join bills b on p.patient_id=b.patient_id where b.paid!=0;

-- Q18: List doctor specialties along with the total number of patients they treated.
select d.speciality, count(a.patient_id) from doctors d join appointments a on d.doc_id=a.doc_id group by d.speciality;

-- Q19: Count male and female patients separately.
select gender, count(*) from patients group by gender; 

