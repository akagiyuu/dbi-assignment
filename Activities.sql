CREATE PROCEDURE AddActivity
	@Name text,
	@Description text,
	@ActivityDate DATE
AS
	INSERT INTO Activities VALUES (@Name, @Description, @ActivityDate)


EXEC AddActivity 'Badminton', 'Badminton Competition', '2024-09-23'
	SELECT * FROM Activities
--
CREATE PROCEDURE UpdateActivity
	@ActivityId int,
	@Name text,
	@Description text,
	@ActivityDate DATE
AS
	UPDATE Activities SET Name = @Name, Description = @Description, ActivityDate = @ActivityDate WHERE ID = @ActivityId

EXEC UpdateActivity 3, 'SWIMMING', 'SWIMMING PRACTICE', '2024-11-12'
--
CREATE PROCEDURE DeleteActivity
	@ActivityId int
AS
	DELETE Activities WHERE ID = @ActivityId

EXEC DeleteActivity 3
--
CREATE PROCEDURE GetActivityByStudent
	@StuID INT
AS
	SELECT A.* FROM StudentActivity S
	JOIN Activities A ON S.ActivityID = A.ID
	WHERE StudentID = @StuID

EXEC GetActivityByStudent 1
--
CREATE PROCEDURE GetStudentsByActivity
	@ActivityID INT
AS
	SELECT St.* FROM StudentActivity S
	JOIN Students St on s.StudentID = St.ID
	JOIN Activities A ON S.ActivityID = A.ID
	WHERE ActivityID = @ActivityID

EXEC GetStudentsByActivity 1 
