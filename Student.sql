--Add student
CREATE PROCEDURE AddStudent
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @classId int
AS
BEGIN
    INSERT INTO Students (FirstName, LastName, Phone, Email, Address, Gender, DOB, ClassID)
    VALUES (@FirstName, @LastName, @Phone, @Email, @Address, @Gender, @DOB, @classId);
END;

--Update student
CREATE PROCEDURE UpdateStudent
    @ID int,
    @FirstName nvarchar(64),
    @LastName nvarchar(64),
    @Phone char(10),
    @Email nvarchar(128),
    @Address nvarchar(255),
    @Gender int,
    @DOB date,
    @classId int
AS
BEGIN
    UPDATE Students
    SET FirstName = @FirstName,
        LastName = @LastName,
        Phone = @Phone,
        Email = @Email,
        Address = @Address,
        Gender = @Gender,
        DOB = @DOB,
        ClassID = @classId
    WHERE ID = @ID;
END;

--Delete student
CREATE PROCEDURE DeleteStudent
    @ID int
AS
BEGIN
    DELETE FROM Students WHERE ID = @ID;
END;

--Assign Class
CREATE PROCEDURE AssignClassToStudent
    @StudentID int,
    @ClassID int
AS
BEGIN
    -- Kiểm tra xem sinh viên đã được gán vào lớp này chưa
    IF NOT EXISTS (SELECT 1 FROM StudentClass WHERE StudentID = @StudentID AND ClassID = @ClassID)
    BEGIN
        INSERT INTO StudentClass (StudentID, ClassID)
        VALUES (@StudentID, @ClassID);
    END
    ELSE
    BEGIN
        PRINT '';
    END
END;

--Change Class
CREATE PROCEDURE ChangeClassForStudent
    @StudentID int,
    @NewClassID int
AS
BEGIN
    -- Cập nhật lớp mới cho sinh viên
    UPDATE StudentClass
    SET ClassID = @NewClassID
    WHERE StudentID = @StudentID;
END;

--View students
CREATE PROCEDURE GetStudentsByClass
    @ClassID int
AS
BEGIN
    SELECT S.ID, S.FirstName, S.LastName, S.Phone, S.Email, S.Address, S.DOB, S.ClassID
    FROM Students S
    INNER JOIN StudentClass SC ON S.ID = SC.StudentID
    WHERE SC.ClassID = @ClassID;
END;
