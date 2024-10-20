CREATE PROCEDURE RecordScore
	@StudentID INT,
    @SubjectID INT,
    @Score FLOAT,
    @ScoreDate DATE
AS
	BEGIN
	    IF EXISTS (SELECT 1 FROM Scores WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate)
		BEGIN 
			PRINT 'This score already recorded'
		END
		ELSE
		BEGIN 
			INSERT INTO Scores (StudentID, SubjectID, Score, ScoreDate) VALUES (@StudentID, @SubjectID, @Score, @ScoreDate)
		END	
	END

EXEC RecordScore 2, 1, 10, '2024-09-25'
SELECT * FROM Scores

--

CREATE PROCEDURE UpdateScore
    @StudentID INT,
    @SubjectID INT,
    @Score FLOAT,
    @ScoreDate DATE
AS
	BEGIN    
		IF EXISTS (SELECT 1 FROM Scores WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate)
		BEGIN
			UPDATE Scores
				 SET Score = @Score
					WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate;
        END
		ELSE
		BEGIN 
		PRINT 'RECORD NOT FOUND'
		END
	END

EXEC UpdateScore 2, 1, 6.5, '2024-09-25'
--
CREATE PROCEDURE DeleteScore
    @StudentID INT,
    @SubjectID INT,
    @ScoreDate DATE
AS
	BEGIN    
		IF EXISTS (SELECT 1 FROM Scores WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate)
		BEGIN
			DELETE Scores
				WHERE StudentID = @StudentID AND SubjectID = @SubjectID AND ScoreDate = @ScoreDate;
        END
		ELSE
		BEGIN 
		PRINT 'RECORD NOT FOUND'
		END
	END

	EXEC DeleteScore 2, 1, '2024-09-25'

	--
CREATE PROCEDURE GetStudentScore
	@StuID INT
AS
	SELECT SubjectID, Score, ScoreDate FROM Scores
						WHERE StudentID = @StuID

	EXEC GetStudentScore 1

CREATE PROCEDURE GetRecordStudentByClass
	@ClassID INT
AS
	SELECT S.* FROM Scores S 
	JOIN Subjects Sj ON S.SubjectID = SJ.ID
	JOIN TeacherSubject TS ON SJ.ID = TS.SubjectID
	JOIN TeacherClass TC ON TS.TeacherID = TC.TeacherID
	JOIN Classes C ON TC.ClassID = C.ID
	WHERE C.ID = @ClassID

	EXEC GetRecordStudentByClass 2
	--
CREATE PROCEDURE GetRecordStudentBySubject
	@SubjectID INT
AS
	SELECT S.* FROM Scores S 
	JOIN Subjects Sj ON S.SubjectID = SJ.ID
	WHERE SJ.ID = @SubjectID

	EXEC GetRecordStudentBySubject 2

CREATE PROCEDURE GetRecordStudentByDateRange
	@StartDate DATE,
	@EndDate DATE
AS
	SELECT * FROM Scores 
	WHERE ScoreDate BETWEEN @StartDate AND @EndDate

	EXEC GetRecordStudentByDateRange '2024-09-01', '2024-09-30'
