CREATE TABLE students (
    student_id int,
    first_name varchar,
	Last_name varchar,
    email varchar,
    phone varchar,
    birthdate varchar);
	


INSERT INTO students
    VALUES (1, 'Seun', 'Ade', 'Seunade@gmail.com', '573-7722', '1945-09-09');
INSERT INTO students
    VALUES (2, 'Timi', 'Dare', 'Timidare@gmail.com', '573-7692', '1995-11-08');
INSERT INTO students
    VALUES (3, 'Joshua', 'Odun', 'Joshuaodun@gmail.com', '573-7042', '1965-12-07');
INSERT INTO students
    VALUES (4, 'Gabby', 'Phil', 'Gabbyphil@gmail.com', '573-4822', '1989-01-06');
INSERT INTO students
    VALUES (1, 'Julia', 'Sumo', 'Juliasumo@gmail.com', '573-5709', '1992-10-05');



--To Validate the table--
select * 
from students


---Create a student grade table--
CREATE TABLE student_grades(
    student_id int,
	test varchar,
	grade int);



INSERT INTO student_grades
     VALUES (1, 'Nutrition', 93);
INSERT INTO student_grades
     VALUES (2, 'Nutrition', 91);
INSERT INTO student_grades
     VALUES (1, 'Chemistry', 90);
INSERT INTO student_grades
     VALUES (2, 'Physics', 99);

select *
from students;


select *
from student grades

---inner join--- returns only the record of all matching values
SELECT
    students.first_name,
	students.last_name,
	students.email,
	student_grades.test,
	student_grades.grade
FROM students
INNER JOIN student_grades
ON students.student_id = student_grades.student_id
WHERE grade > 90




--Left join-- returns null in the left table when no match is found
SELECT
    students.student_id,
	students.first_name,
	students.last_name,
	student_grades.test,
	student_grades.grade
FROM students
LEFT JOIN student_grades
ON students.student_id = student_grades.student_id;



--Right join-- returns null in the left table when no match is found
SELECT
    student_grades.grade,
	students.student_id,
	students.first_name,
	students.last_name
FROM student_grades
RIGHT JOIN students
ON student_grades.student_id = students.student_id;


---Full Outer Join
SELECT *
    FROM students
    FULL OUTER JOIN student_grades
    ON students.student_id = student_grades.student_id;




	 