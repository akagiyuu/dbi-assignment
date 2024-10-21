-- Genders
INSERT INTO Genders (Name) VALUES ('Male'), ('Female');

-- Students
INSERT INTO Students (FirstName, LastName, Phone, Email, Address, Gender, DOB)
VALUES ('John', 'Doe', '1234567890', 'john@example.com', '123 Main St', 1, '2006-05-12'),
       ('Jane', 'Smith', '0987654321', 'jane@example.com', '456 Oak St', 2, '2007-08-25');

-- Parents
INSERT INTO Parents (FirstName, LastName, Phone, Email, StudentID)
VALUES ('Michael', 'Doe', '2345678901', 'michael@example.com', 1),
       ('Susan', 'Smith', '8765432109', 'susan@example.com', 2);

-- Activities
INSERT INTO Activities (Name, Description, ActivityDate)
VALUES ('Football', 'Football Practice', '2024-10-01'),
       ('Math Club', 'Math Competition', '2024-11-01');

-- StudentActivity
INSERT INTO StudentActivity (StudentID, ActivityID) 
VALUES (1, 1), 
       (1, 2),
       (2, 2);

-- Classes
INSERT INTO Classes (Name) VALUES ('Class A'), ('Class B');

-- Subjects
INSERT INTO Subjects (Name) VALUES ('Math'), ('Science');

-- Teachers
INSERT INTO Teachers (FirstName, LastName, Phone, Email, Address, Gender, DOB, HiredDate, SubjectID)
VALUES ('Alice', 'Johnson', '3456789012', 'alice.j@example.com', '789 Pine St', 2, '1990-07-15', '2015-09-01', 1),
       ('Bob', 'Williams', '4567890123', 'bob.w@example.com', '321 Maple St', 1, '1988-03-22', '2010-01-15', 2);

-- TeacherClass
INSERT INTO TeacherClass (TeacherID, ClassID) VALUES (1, 1), (2, 2);

-- Scores
INSERT INTO Scores (StudentID, SubjectID, Score, ScoreDate) 
VALUES (1, 1, 8.5, '2024-09-20'),
       (2, 2, 9.0, '2024-09-18'),
       (1, 2, 7.5, '2024-09-25');  -- Added missing score for the second subject
