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