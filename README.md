# sql_practice

## patients table 

primary key icon	patient_id	INT
first_name	TEXT
last_name	TEXT
gender	CHAR(1)
birth_date	DATE
city	TEXT
primary key icon	province_id	CHAR(2)
allergies	TEXT
height	INT
weight	INT

## admissions table 

patient_id	INT
admission_date	DATE
discharge_date	DATE
diagnosis	TEXT
primary key icon	attending_doctor_id	INT

## doctors table 

doctor_id	INT
first_name	TEXT
last_name	TEXT
specialty	TEXT

## province_names table 

province_id	CHAR(2)
province_name	TEXT


