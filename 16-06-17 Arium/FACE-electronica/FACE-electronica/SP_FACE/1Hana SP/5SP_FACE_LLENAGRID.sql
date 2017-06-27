CREATE PROCEDURE SP_FACE_LLENAGRID
LANGUAGE SQLSCRIPT
AS

BEGIN
select  
A."Series",
A."SeriesName", 
Case "ObjectCode" WHEN 13 THEN 
	CASE "DocSubType" WHEN 'DN' THEN 
		'Nota de Debito' 
	ELSE 'Factura' 
END 
ELSE 
	CASE "ObjectCode" WHEN 14 THEN 
		'Nota de Credito' 
	ELSE 'Factura Proveedor' 
	END 
End "Tipo Serie",
Case iFnull(B."U_SERIE", '100') WHEN '100' THEN '0' ELSE 'Y' End AS "Es documento electrónico",
B."U_RESOLUCION" AS "Resolucion",
B."U_AUTORIZACION" AS "Autorizacion",
B."U_FECHA_AUTORIZACION" AS "Fecha", 
B."U_FACTURA_DEL" AS "De la Factura", 
B."U_FACTURA_AL" AS "A la factura",
B."U_TIPO_DOC" AS "Tipo Documento",
Case iFnull(B."U_ES_BATCH", '100') WHEN '100' THEN '0'	ELSE 'Y' End AS "Es batch" ,
B."U_SUCURSAL" AS "# Sucursal",
B."U_NOMBRE_SUCURSAL" AS "Nombre Sucursal", 
B."U_DISPOSITIVO" AS "# Dispositivo",
B."U_DIR_SUCURSAL" AS "Direccion Sucursal",
B."U_MUNI_SUCURSAL" AS "Municipio", 
B."U_DEPTO_SUCURSAL" AS "Departamento",
B."U_USUARIO" AS "Usuario GFACE", 
B."U_CLAVE" AS "Clave GFACE" 
FROM 
	NNM1 A left outer join "@FACE_RESOLUCION" B on  A."Series" = B."U_SERIE"
    where A."ObjectCode" in ('13','14','18','2','4')                     
    order by A."ObjectCode",A."DocSubType";
END;