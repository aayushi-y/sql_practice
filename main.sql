/*Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.

For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.*/

select count(*) as patients_in_group, 
	CASE 
    	when weight>=0 AND weight <10 THen 0
        when weight>=10 AND weight <20 THen 10
        when weight>=20 AND weight <30 THen 20
        when weight>=30 AND weight <40 THen 30
        when weight>=40 AND weight <50 THen 40
        when weight>=50 AND weight <60 THen 50
        when weight>=60 AND weight <70 THen 60
        when weight>=70 AND weight <80 THen 70
        when weight>=80 AND weight <90 THen 80
        when weight>=90 AND weight <100 THen 90
        when weight>=100 AND weight <110 THen 100
        when weight>=110 AND weight <120 THen 110
        when weight>=120 AND weight <130 THen 120
        when weight>=130 AND weight <140 THen 130
        when weight>=140 AND weight <150 THen 140
     END as weight_group 
     	from patients
        	group by weight_group
     			order by weight_group DESC

/*Show patient_id, weight, height, isObese from the patients table.

Display isObese as a boolean 0 or 1.

Obese is defined as weight(kg)/(height(m)2) >= 30.

weight is in units kg.

height is in units cm. */

select patient_id, weight, height,
	CASE 
    	WHEN (weight/Power(height, 2))*10000 >= 30 THEN 1
        WHEN (weight/Power(height, 2))*10000 < 30 THEn 0 
    END AS isObese 
    	from patients

/*Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

Check patients, admissions, and doctors tables for required information. */

select patients.patient_id, patients.first_name, patients.last_name, doctors.specialty
	FRom patients JOIN admissions JOIN doctors
    	ON patients.patient_id = admissions.patient_id
        	AND admissions.attending_doctor_id = doctors.doctor_id
            	where admissions.diagnosis = 'Epilepsy'
                	AND doctors.first_name = 'Lisa'

/*All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date*/

select p.patient_id, concat(p.patient_id, LEN(p.last_name), YEAR(p.birth_date)) AS temp_password 
	FROM patients p JOIN admissions a 
    	ON p.patient_id = a.patient_id
        	group by p.patient_id

/*Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.

Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.*/

select 
	CASe 
    	WHen patient_id%2 == 0 Then 'Yes'
        WHEN patient_id%2 != 0 THEN 'No'
    END AS has_insurance,
    CASE 
    	WHEN patient_id%2 == 0 THEN count(*) * 10 
        WHEN patient_id%2 != 0 THEN count(*) * 50
    END as cost_after_insurance
    	FROM admissions
    group by has_insurance

/*Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name*/

select province_names.province_name 
	FRom 
    	province_names JOIn patients
        	ON province_names.province_id = patients.province_id
        		group by province_names.province_name
            		having COUNT(case WHEN patients.gender = 'M' THEN 1 END) > COUNT(case WHEN patients.gender = 'F' THEN 1 END);

/*We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston' */

select * from patients
    	WHERE city = 'Kingston' AND 
        	first_name LIKE '__r%' AND 
            	gender = 'F' AND
                	month(birth_date) IN (2, 5,12) AND 
                    	weight between 60 AND 80 AND 
                        	patient_id % 2 != 0

/*Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form. */

/*For each day display the total amount of admissions on that day. Display the amount changed from the previous date. */
WITH temptable AS (
	select admission_date,
	   count(*) AS admission_day
	from admissions
  	group by admission_date
)
select admission_date, admission_day, admission_day - LAG(admission_day,1)
	OVER() admission_count_change
    	from temptable



/*Sort the province names in ascending order in such a way that the province 'Ontario' is always on top. */
select 
	province_name 
    	from province_names
        	order by case when province_name = 'Ontario' Then 0 else 1 END 

/*We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year. */
select
	d.doctor_id, concat(d.first_name, ' ', d.last_name) AS doctor_name, 
    d.specialty, YEar(a.admission_date) AS selected_year, 
    count(*) AS total_admissions
	from admissions a JOin doctors d
    	On a.attending_doctor_id = d.doctor_id
        	group by d.doctor_id, d.specialty, selected_year
