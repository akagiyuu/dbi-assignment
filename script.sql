CREATE TABLE Classes(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(32) NOT NULL UNIQUE
);

CREATE TABLE Genders(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(32) NOT NULL UNIQUE
);

CREATE TABLE Students(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName nvarchar(64) NOT NULL,
	LastName nvarchar(64) NOT NULL,
	Phone char(10) NOT NULL UNIQUE,
	Email nvarchar(64) NOT NULL UNIQUE,
	Address nvarchar(128) NOT NULL,
	Gender int REFERENCES Genders(ID) NOT NULL,
	DOB date NOT NULL CHECK (YEAR(GETDATE()) - YEAR(DOB) BETWEEN 16 AND 18),
    ClassID int REFERENCES Classes(ID),
);

CREATE TABLE Parents(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName nvarchar(64) NOT NULL,
	LastName nvarchar(64) NOT NULL,
	Phone char(10) NOT NULL,
	Email nvarchar(128) NOT NULL,
	StudentID int NOT NULL REFERENCES Students(ID) ON DELETE CASCADE
);

CREATE TABLE Activities(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(128) NOT NULL,
	Description text NOT NULL,
	ActivityDate date NOT NULL,
);

CREATE TABLE StudentActivity(
	StudentID int NOT NULL REFERENCES Students(ID) ON DELETE CASCADE,
	ActivityID int NOT NULL REFERENCES Activities(ID) ON DELETE CASCADE,

	PRIMARY KEY (StudentID, ActivityID)
);

CREATE TABLE Subjects(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Name nvarchar(32) NOT NULL UNIQUE
);

CREATE TABLE Teachers(
	ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FirstName nvarchar(64) NOT NULL,
	LastName nvarchar(64) NOT NULL,
	Phone char(10) NOT NULL UNIQUE,
	Email nvarchar(128) NOT NULL UNIQUE,
	Address nvarchar(255) NOT NULL,
	Gender int REFERENCES Genders(ID) NOT NULL,
	DOB date NOT NULL CHECK (YEAR(GETDATE()) - YEAR(DOB) >= 22),
	HiredDate date NOT NULL CHECK (HiredDate < GETDATE()),
    SubjectID int NOT NULL REFERENCES Subjects(ID) ON DELETE CASCADE
);

CREATE TABLE TeacherClass(
	TeacherID int NOT NULL REFERENCES Teachers(ID) ON DELETE CASCADE,
	ClassID int NOT NULL REFERENCES Classes(ID) ON DELETE CASCADE,
	
	PRIMARY KEY (TeacherID, ClassID)
);

CREATE TABLE Scores(
	StudentID int NOT NULL REFERENCES Students(ID) ON DELETE CASCADE,
	SubjectID int NOT NULL REFERENCES Subjects(ID) ON DELETE CASCADE,
	Score float CHECK (Score BETWEEN 0 AND 10),
	ScoreDate date NOT NULL CHECK (ScoreDate < GETDATE()),

	PRIMARY KEY (StudentID, SubjectID, ScoreDate)
);
GO

CREATE TRIGGER UnAssignStudentFromRemovedClass
ON Classes
INSTEAD OF DELETE
AS
BEGIN TRANSACTION;
	DECLARE @ClassID int = (SELECT ID FROM deleted)
	UPDATE Students SET ClassID = NULL WHERE ClassID = @ClassID
	--DELETE TeacherClass WHERE ClassID = @ClassID
	DELETE Classes WHERE ID = @ClassID
	IF @@ERROR <>0
		ROLLBACK TRANSACTION
COMMIT TRANSACTION;

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
GO

CREATE PROCEDURE AddClass
	@ClassName NVARCHAR(32)
AS
	INSERT INTO Classes VALUES (@ClassName)
GO

-- EXEC AddClass 'Class C'
-- SELECT * FROM Classes

CREATE PROCEDURE UpdateClass
	@ClassID int,
	@ClassName NVARCHAR(32)
AS
	UPDATE Classes SET Name = @ClassName WHERE ID = @ClassID
GO

-- EXEC UpdateClass 3, 'Class D'
-- SELECT * FROM Classes

CREATE PROCEDURE DeleteCLass
	@ClassID int
AS
	DELETE Classes WHERE ID = @ClassID
GO

-- EXEC DeleteCLass 1
-- SELECT * FROM Classes
-- SEELCT * FROM Students
-- SELECT * FROM TeacherClass

CREATE PROCEDURE AssignTeacherToClass
	@TeacherID INT,
	@ClassID INT
AS
    INSERT INTO TeacherClass(TeacherID, ClassID)
    VALUES (@TeacherID, @ClassID)
GO

-- EXEC AssignTeacherToClass 1,3
-- EXEC AssignTeacherToClass 2,3
-- SELECT * FROM TeacherClass

CREATE PROCEDURE AddTeacher
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @HiredDate date,
	@SubjectID int
AS
    INSERT INTO Teachers (FirstName, LastName, Phone, Email, Address, Gender, DOB, HiredDate, SubjectID )
    VALUES (@FirstName, @LastName, @Phone, @Email, @Address, @Gender, @DOB, @HiredDate, @SubjectID)
GO

CREATE PROCEDURE UpdateTeacher
    @ID int,
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @HiredDate date,
	@SubjectID int
AS
    UPDATE Teachers
    SET FirstName = @FirstName,
        LastName = @LastName,
        Phone = @Phone,
        Email = @Email,
        Address = @Address,
        Gender = @Gender,
        DOB = @DOB,
        HiredDate = @HiredDate,
		SubjectID  = @SubjectID
    WHERE ID = @ID
GO

CREATE PROCEDURE DeleteTeacher
    @ID int
AS
    DELETE FROM Teachers WHERE ID = @ID
GO

CREATE PROCEDURE AssignSubjectToTeacher
    @TeacherID int,
    @SubjectID int
AS
    UPDATE Teachers
	SET SubjectID = @SubjectID
	WHERE ID = @TeacherID
GO

CREATE PROCEDURE GetTeachersBySubject
    @SubjectID int
AS
    SELECT *
    FROM Teachers T
	WHERE SubjectID = @SubjectID
GO

CREATE PROCEDURE GetTeachersByClass
    @ClassID int
AS
    SELECT T.* 
    FROM Teachers T
    INNER JOIN TeacherClass TC ON T.ID = TC.TeacherID
    WHERE TC.ClassID = @ClassID
GO

--EXEC AddTeacher 'C', 'Johnson', '3456789018', 'c.j@example.com', '789 Pine St', 2, '1990-07-15', '2015-09-01', 1
--SELECT * FROM Teachers

--EXEC UpdateTeacher 3, 'D', 'Johnson', '3456789018', 'c.j@example.com', '789 Pine St', 2, '1990-07-15', '2015-09-01', 1
--SELECT * FROM Teachers

--EXEC DeleteTeacher 3
--SELECT * FROM Teachers

--EXEC AssignSubjectToTeacher 2, 1
--SELECT * FROM Teachers

--EXEC GetTeachersBySubject 1

--EXEC GetTeachersByClass 1

CREATE PROCEDURE AddStudent
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @ClassID int
AS
    INSERT INTO Students (FirstName, LastName, Phone, Email, Address, Gender, DOB, ClassID)
    VALUES (@FirstName, @LastName, @Phone, @Email, @Address, @Gender, @DOB, @ClassID);
GO

CREATE PROCEDURE UpdateStudent
    @ID int,
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @ClassID int
AS
    UPDATE Students
    SET FirstName = @FirstName,
        LastName = @LastName,
        Phone = @Phone,
        Email = @Email,
        Address = @Address,
        Gender = @Gender,
        DOB = @DOB,
        ClassID = @ClassID
    WHERE ID = @ID;
GO

CREATE PROCEDURE DeleteStudent
    @ID int
AS
    DELETE FROM Students WHERE ID = @ID;
GO

CREATE PROCEDURE AssignStudentToClass
    @StudentID int,
    @ClassID int
AS
    UPDATE Students
	SET ClassID = @ClassID
	WHERE ID = @StudentID
GO

CREATE PROCEDURE GetStudentsByClass
    @ClassID int
AS
    SELECT *
    FROM Students 
    WHERE ClassID = @ClassID
GO

--EXEC AddStudent 'John', 'Doe', '1234567889', 'john2@example.com', '123 Main St', 1, '2006-05-12', 1
--SELECT * FROM Students

--EXEC UpdateStudent 3, 'Test', 'Doe', '1234567889', 'john2@example.com', '123 Main St', 1, '2006-05-12', 1
--SELECT * FROM Students

--EXEC DeleteStudent 3
--SELECT * FROM Students

--EXEC AssignStudentToClass 1, 1
--EXEC AssignStudentToClass 2, 2
--SELECT * FROM Students

--EXEC GetStudentsByClass 1

CREATE PROCEDURE AddParent
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @StudentID int
AS
    INSERT INTO Parents (FirstName, LastName, Phone, Email, StudentID)
    VALUES (@FirstName, @LastName, @Phone, @Email, @StudentID)
GO

CREATE PROCEDURE UpdateParent
    @ParentID int,
    @FirstName nvarchar(64) = NULL,
    @LastName nvarchar(64) = NULL,
    @Phone char(10) = NULL,
    @Email nvarchar(128) = NULL
AS
    UPDATE Parents
    SET 
        FirstName = COALESCE(@FirstName, FirstName),
        LastName = COALESCE(@LastName, LastName),
        Phone = COALESCE(@Phone, Phone),
        Email = COALESCE(@Email, Email)
    WHERE ID = @ParentID;
GO

CREATE PROCEDURE DeleteParent
    @ParentID int
AS
    DELETE FROM Parents
    WHERE ID = @ParentID;
GO

CREATE PROCEDURE ViewParentByStudent
    @StudentID int
AS
    SELECT *
    FROM Parents
    WHERE StudentID = @StudentID;
GO

--EXEC AddParent 'Test', 'Test', '1245678945', 'test@example.com', 1
--EXEC ViewParentByStudent 1

--EXEC UpdateParent 3, @FirstName = 'ok'
--EXEC ViewParentByStudent 1

--EXEC DeleteParent 3
--EXEC ViewParentByStudent 1

CREATE PROCEDURE AddSubject
	@Name nvarchar(32)
AS 
	INSERT INTO Subjects (Name)
	VALUES (@Name)
GO
 
CREATE PROCEDURE UpdateSubject 
    @SubjectID int, 
    @Name nvarchar(32)
AS
    UPDATE Subjects
    SET Name = @Name
    WHERE ID = @SubjectID 
GO

CREATE PROCEDURE DeleteSubject 
	@SubjectID int
AS 
	DELETE FROM Subjects
	WHERE ID = @SubjectID
GO

--EXEC AddSubject 'Biology'
--SELECT * FROM Subjects

--EXEC UpdateSubject 3, 'Bio'
--SELECT * FROM Subjects

--EXEC DeleteSubject 3
--SELECT * FROM Subjects

CREATE PROCEDURE RecordScore
	@StudentID INT,
    @SubjectID INT,
    @Score FLOAT,
    @ScoreDate DATE
AS 
	INSERT INTO Scores (StudentID, SubjectID, Score, ScoreDate)
	VALUES (@StudentID, @SubjectID, @Score, @ScoreDate)
GO

CREATE PROCEDURE UpdateScore
    @StudentID INT,
    @SubjectID INT,
    @Score FLOAT,
    @ScoreDate DATE
AS  
	UPDATE Scores
	SET Score = @Score
	WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate
GO

--
CREATE PROCEDURE DeleteScore
    @StudentID INT,
    @SubjectID INT,
    @ScoreDate DATE
AS
	DELETE Scores
	WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate
GO


CREATE PROCEDURE GetStudentScore
	@StudentID INT
AS
	SELECT SubjectID, Score, ScoreDate FROM Scores
	WHERE StudentID = @StudentID
GO

CREATE PROCEDURE GetScoreByClass
	@ClassID INT
AS
	SELECT S.*
	FROM Scores S
	INNER JOIN Students ON Students.ID = S.StudentID
	WHERE ClassID = @ClassID
GO

	--
CREATE PROCEDURE GetScoreBySubject
	@SubjectID INT
AS
	SELECT S.* FROM Scores S 
	JOIN Subjects Sj ON S.SubjectID = SJ.ID
	WHERE SJ.ID = @SubjectID
GO

CREATE PROCEDURE GetScoreByDateRange
	@StartDate DATE,
	@EndDate DATE
AS
	SELECT * FROM Scores 
	WHERE ScoreDate BETWEEN @StartDate AND @EndDate
GO

--EXEC RecordScore 2, 1, 10, '2024-09-25'
--EXEC GetStudentScore 2

--EXEC UpdateScore 2, 1, 6.5, '2024-09-25'
--EXEC GetStudentScore 2

--EXEC DeleteScore 2, 1, '2024-09-25'
--EXEC GetStudentScore 2

--EXEC GetScoreByClass 2

--EXEC GetScoreBySubject 2

--EXEC GetScoreByDateRange '2024-09-01', '2024-09-30'

CREATE PROCEDURE AddActivity
	@Name text,
	@Description text,
	@ActivityDate DATE
AS
	INSERT INTO Activities VALUES (@Name, @Description, @ActivityDate)
GO

CREATE PROCEDURE UpdateActivity
	@ActivityID int,
	@Name text,
	@Description text,
	@ActivityDate DATE
AS
	UPDATE Activities
	SET Name = @Name, Description = @Description, ActivityDate = @ActivityDate
	WHERE ID = @ActivityID
GO

CREATE PROCEDURE DeleteActivity
	@ActivityID int
AS
	DELETE Activities WHERE ID = @ActivityID
GO

CREATE PROCEDURE GetActivityByStudent
	@StudentID INT
AS
	SELECT A.* FROM StudentActivity S
	JOIN Activities A ON S.ActivityID = A.ID
	WHERE StudentID = @StudentID
GO

CREATE PROCEDURE GetStudentsByActivity
	@ActivityID INT
AS
	SELECT St.* FROM StudentActivity S
	JOIN Students St on s.StudentID = St.ID
	JOIN Activities A ON S.ActivityID = A.ID
	WHERE ActivityID = @ActivityID
GO

--EXEC AddActivity 'Badminton', 'Badminton Competition', '2024-09-23'
--SELECT * FROM Activities

--EXEC UpdateActivity 3, 'SWIMMING', 'SWIMMING PRACTICE', '2024-11-12'
--SELECT * FROM Activities

--EXEC DeleteActivity 3
--SELECT * FROM Activities

--EXEC GetActivityByStudent 1

--EXEC GetStudentsByActivity 1
