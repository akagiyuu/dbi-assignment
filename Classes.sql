
CREATE TABLE Genders(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(32) NOT NULL,
);

CREATE TABLE Students(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName nvarchar(64) NOT NULL,
	LastName nvarchar(64) NOT NULL,
	Phone char(10) NOT NULL,
	Email nvarchar(128) NOT NULL,
	Address nvarchar(255) NOT NULL,
	Gender int REFERENCES Genders(ID) NOT NULL,
	DOB date NOT NULL CHECK (YEAR(GETDATE()) - YEAR(DOB) BETWEEN 16 AND 18)
);

CREATE TABLE Parents(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName nvarchar(64) NOT NULL,
	LastName nvarchar(64) NOT NULL,
	Phone char(10) NOT NULL,
	Email nvarchar(128) NOT NULL,
	StudentID int NOT NULL REFERENCES Students(ID)
);

CREATE TABLE Activities(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name text NOT NULL,
	Description text NOT NULL,
	ActivityDate date NOT NULL,
);

CREATE TABLE StudentActivity(
	StudentID int NOT NULL REFERENCES Students(ID),
	ActivityID int NOT NULL REFERENCES Activities(ID),

	PRIMARY KEY (StudentID, ActivityID)
);


CREATE TABLE Classes(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(32) NOT NULL
);

CREATE TABLE Subjects(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(32) NOT NULL
);

CREATE TABLE Teachers(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName nvarchar(64) NOT NULL,
	LastName nvarchar(64) NOT NULL,
	Phone char(10) NOT NULL,
	Email nvarchar(128) NOT NULL,
	Address nvarchar(255) NOT NULL,
	Gender int REFERENCES Genders(ID) NOT NULL,
	DOB date NOT NULL CHECK (YEAR(GETDATE()) - YEAR(DOB) >= 22),
	HiredDate date NOT NULL CHECK (HiredDate < GETDATE())
);

CREATE TABLE TeacherSubject(
	TeacherID int NOT NULL REFERENCES Teachers(ID),
	SubjectID int NOT NULL REFERENCES Subjects(ID),
	
	PRIMARY KEY (TeacherID, SubjectID)
);

CREATE TABLE TeacherClass(
	TeacherID int NOT NULL REFERENCES Teachers(ID),
	ClassID int NOT NULL REFERENCES Classes(ID),
	
	PRIMARY KEY (TeacherID, ClassID)
);

CREATE TABLE Scores(
	StudentID int NOT NULL REFERENCES Students(ID),
	SubjectID int NOT NULL REFERENCES Subjects(ID),
	Score float CHECK (Score BETWEEN 0 AND 10),
	ScoreDate date NOT NULL CHECK (ScoreDate < GETDATE()),

	PRIMARY KEY (StudentID, SubjectID, ScoreDate)
);

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
INSERT INTO Teachers (FirstName, LastName, Phone, Email, Address, Gender, DOB, HiredDate)
VALUES ('Alice', 'Johnson', '3456789012', 'alice.j@example.com', '789 Pine St', 2, '1990-07-15', '2015-09-01'),
       ('Bob', 'Williams', '4567890123', 'bob.w@example.com', '321 Maple St', 1, '1988-03-22', '2010-01-15');

-- TeacherSubject
INSERT INTO TeacherSubject (TeacherID, SubjectID) VALUES (1, 1), (2, 2);

-- TeacherClass
INSERT INTO TeacherClass (TeacherID, ClassID) VALUES (1, 1), (2, 2);

-- Scores
INSERT INTO Scores (StudentID, SubjectID, Score, ScoreDate) 
VALUES (1, 1, 8.5, '2024-09-20'),
       (2, 2, 9.0, '2024-09-18'),
       (1, 2, 7.5, '2024-09-25');  -- Added missing score for the second subject

SELECT * FROM Activities;


--ADD
CREATE PROCEDURE AddClass
	@ClassName NVARCHAR(32)
	AS
	INSERT INTO Classes VALUES (@ClassName)

EXEC AddClass 'Class C'

SELECT * FROM Classes

CREATE PROCEDURE UpdateClass
	@ClassId int,
	@ClassName NVARCHAR(32)
AS
	UPDATE Classes SET Name = @ClassName WHERE ID = @ClassId

EXEC UpdateClass 3, 'Class D'
SELECT * FROM Classes

CREATE PROCEDURE DeleteCLass
	@ClassId int
AS
	DELETE Classes WHERE ID = @ClassId

EXEC DeleteCLass 4

SELECT * FROM Classes

GO
CREATE PROCEDURE TeachersAssignClass
	@TeacherId INT,
	@ClassId INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TeacherClass WHERE TeacherID = @TeacherID AND ClassID = @ClassId)
    BEGIN
        INSERT INTO TeacherClass(TeacherID, ClassID)
        VALUES (@TeacherID, @ClassId);
    END
    ELSE
    BEGIN
        PRINT 'Class has been add';
    END
END;

SELECT * FROM TeacherClass
