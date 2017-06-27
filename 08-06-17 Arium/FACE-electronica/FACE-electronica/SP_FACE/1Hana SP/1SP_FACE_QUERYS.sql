CREATE PROCEDURE SP_FACE_QUERYS
(IN
condicion int,
param1 NVARCHAR(100),
param2 NVARCHAR(100)
)
LANGUAGE SQLSCRIPT
AS

BEGIN
--Condicion 1 = AddUserFields
--Condicion 2 = delete @Face_tipodoc
--Condicion 3 y 4 = addDocumentType
--Condicion 5 = select parametros
--Condicion 6 = inserts

/***** CONDICION 1 *****/
--TableID = TableName
--AliasID = FieldName
	IF (:condicion = 1) THEN 
		SELECT "TableID","FieldID","AliasID" FROM "CUFD" WHERE "TableID"= :param1 AND "AliasID"  = :param2;
	END IF;
/***** CONDICION 2 *****/
	IF (:condicion = 2) THEN
		DELETE FROM "@FACE_TIPODOC";
	END IF;
/***** CONDICION 5 *****/
	IF (:condicion = 5) THEN
		SELECT * FROM "@FACE_PARAMETROS";
	END IF;

/***** CONDICION 7 *****/
	IF (:condicion = 7) THEN
		DELETE FROM "@FACE_RESOLUCION";
	END IF;

/***** CONDICION 18 *****/
	IF (:condicion = 18) THEN
		select "TableID","FieldID","AliasID" from "CUFD" WHERE "TableID"= :param1 and "AliasID"  = :param2;	
	END IF;
	
END;