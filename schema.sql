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
