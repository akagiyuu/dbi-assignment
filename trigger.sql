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