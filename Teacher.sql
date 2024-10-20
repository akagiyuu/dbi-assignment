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

--Add teacher
CREATE PROCEDURE AddTeacher
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @HiredDate date
AS
BEGIN
    INSERT INTO Teachers (FirstName, LastName, Phone, Email, Address, Gender, DOB, HiredDate)
    VALUES (@FirstName, @LastName, @Phone, @Email, @Address, @Gender, @DOB, @HiredDate);
END;

--Update teacher
CREATE PROCEDURE UpdateTeacher
    @ID int,
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @HiredDate date
AS
BEGIN
    UPDATE Teachers
    SET FirstName = @FirstName,
        LastName = @LastName,
        Phone = @Phone,
        Email = @Email,
        Address = @Address,
        Gender = @Gender,
        DOB = @DOB,
        HiredDate = @HiredDate
    WHERE ID = @ID;
END;

--Delete teacher
CREATE PROCEDURE DeleteTeacher
    @ID int
AS
BEGIN
    DELETE FROM Teachers WHERE ID = @ID;
END;

--Assign subjects to teachers
CREATE PROCEDURE AssignSubjectToTeacher
    @TeacherID int,
    @SubjectID int
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM TeacherSubject WHERE TeacherID = @TeacherID AND SubjectID = @SubjectID)
    BEGIN
        INSERT INTO TeacherSubject (TeacherID, SubjectID)
        VALUES (@TeacherID, @SubjectID);
    END
    ELSE
    BEGIN
        PRINT 'Teacher has been add';
    END
END;

--view teacher by subject
CREATE PROCEDURE GetTeachersBySubject
    @SubjectID int
AS
BEGIN
    SELECT T.ID, T.FirstName, T.LastName, T.Phone, T.Email, T.Address, T.DOB, T.HiredDate
    FROM Teachers T
    INNER JOIN TeacherSubject TS ON T.ID = TS.TeacherID
    WHERE TS.SubjectID = @SubjectID;
END;

--view teacher by class
CREATE PROCEDURE GetTeachersByClass
    @ClassID int
AS
BEGIN
    SELECT T.ID, T.FirstName, T.LastName, T.Phone, T.Email, T.Address, T.DOB, T.HiredDate
    FROM Teachers T
    INNER JOIN TeacherClass TC ON T.ID = TC.TeacherID
    WHERE TC.ClassID = @ClassID;
END;
