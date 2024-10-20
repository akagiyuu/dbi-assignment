--Add teacher
CREATE PROCEDURE AddTeacher
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @HiredDate date,
	@idSub int
AS
BEGIN
    INSERT INTO Teachers (FirstName, LastName, Phone, Email, Address, Gender, DOB, HiredDate, idSub)
    VALUES (@FirstName, @LastName, @Phone, @Email, @Address, @Gender, @DOB, @HiredDate, @idSub);
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
    @HiredDate date,
	@idSub int
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
        HiredDate = @HiredDate,
	IdSub = @idSub
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
    SELECT T.ID, T.FirstName, T.LastName, T.Phone, T.Email, T.Address, T.DOB, T.HiredDate, T.IdSub
    FROM Teachers T
    INNER JOIN TeacherSubject TS ON T.ID = TS.TeacherID
    WHERE TS.SubjectID = @SubjectID;
END;

--view teacher by class
CREATE PROCEDURE GetTeachersByClass
    @ClassID int
AS
BEGIN
    SELECT T.ID, T.FirstName, T.LastName, T.Phone, T.Email, T.Address, T.DOB, T.HiredDate, T.IdSub
    FROM Teachers T
    INNER JOIN TeacherClass TC ON T.ID = TC.TeacherID
    WHERE TC.ClassID = @ClassID;
END;
