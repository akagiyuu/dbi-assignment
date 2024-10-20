-- Drop the existing procedure if it exists
IF OBJECT_ID('dbo.AddParent', 'P') IS NOT NULL
BEGIN
    DROP PROCEDURE dbo.AddParent;
END

-- Create the Genders table
CREATE TABLE Genders (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(32) NOT NULL
);

-- Create the Students table
CREATE TABLE Students (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    FirstName nvarchar(64) NOT NULL,
    LastName nvarchar(64) NOT NULL,
    Phone char(10) NOT NULL,
    Email nvarchar(128) NOT NULL,
    Address nvarchar(255) NOT NULL,
    Gender int REFERENCES Genders(ID) NOT NULL,
    DOB date NOT NULL CHECK (YEAR(GETDATE()) - YEAR(DOB) BETWEEN 16 AND 18)
);

-- Create the Parents table
CREATE TABLE Parents (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    FirstName nvarchar(64) NOT NULL,
    LastName nvarchar(64) NOT NULL,
    Phone char(10) NOT NULL,
    Email nvarchar(128) NOT NULL,
    StudentID int NOT NULL REFERENCES Students(ID)
);

-- Create the Activities table
CREATE TABLE Activities (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name text NOT NULL,
    Description text NOT NULL,
    ActivityDate date NOT NULL
);

-- Create the StudentActivity table
CREATE TABLE StudentActivity (
    StudentID int NOT NULL REFERENCES Students(ID),
    ActivityID int NOT NULL REFERENCES Activities(ID),
    PRIMARY KEY (StudentID, ActivityID)
);

-- Create the Classes table
CREATE TABLE Classes (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(32) NOT NULL
);

-- Create the Subjects table
CREATE TABLE Subjects (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Name nvarchar(32) NOT NULL
);

-- Create the Teachers table
CREATE TABLE Teachers (
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

-- Create the TeacherSubject table
CREATE TABLE TeacherSubject (
    TeacherID int NOT NULL REFERENCES Teachers(ID),
    SubjectID int NOT NULL REFERENCES Subjects(ID),
    PRIMARY KEY (TeacherID, SubjectID)
);

-- Create the TeacherClass table
CREATE TABLE TeacherClass (
    TeacherID int NOT NULL REFERENCES Teachers(ID),
    ClassID int NOT NULL REFERENCES Classes(ID),
    PRIMARY KEY (TeacherID, ClassID)
);

-- Create the Scores table
CREATE TABLE Scores (
    StudentID int NOT NULL REFERENCES Students(ID),
    SubjectID int NOT NULL REFERENCES Subjects(ID),
    Score float CHECK (Score BETWEEN 0 AND 10),
    ScoreDate date NOT NULL CHECK (ScoreDate < GETDATE()),
    PRIMARY KEY (StudentID, SubjectID, ScoreDate)
);



CREATE PROCEDURE AddParent
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @StudentID int
AS
BEGIN
    INSERT INTO Parents (FirstName, LastName, Phone, Email, StudentID)
    VALUES (@FirstName, @LastName, @Phone, @Email, @StudentID);
END;

-- này là update 

CREATE PROCEDURE UpdateParent
    @ParentID int,
    @FirstName nvarchar(64) = NULL,
    @LastName nvarchar(64) = NULL,
    @Phone char(10) = NULL,
    @Email nvarchar(128) = NULL
AS
BEGIN
    UPDATE Parents
    SET 
        FirstName = COALESCE(@FirstName, FirstName),
        LastName = COALESCE(@LastName, LastName),
        Phone = COALESCE(@Phone, Phone),
        Email = COALESCE(@Email, Email)
    WHERE ID = @ParentID;
END;

--Xóa

CREATE PROCEDURE DeleteParent
    @ParentID int
AS
BEGIN
    DELETE FROM Parents
    WHERE ID = @ParentID;
END;

-- xem thông tin phụ huynh
CREATE PROCEDURE ViewParentInfoByStudent
    @StudentID int
AS
BEGIN
    SELECT FirstName, LastName, Phone, Email
    FROM Parents
    WHERE StudentID = @StudentID;
END;

EXEC ViewParentInfoByStudent 
    @StudentID = 7;
