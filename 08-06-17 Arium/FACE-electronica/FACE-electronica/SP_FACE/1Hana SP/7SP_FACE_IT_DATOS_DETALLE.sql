CREATE procedure SP_FACE_IT_DATOS_DETALLE 
(in DOCENTRY VARCHAR(10),
TIPODOC char(4)
)

AS
DOCRATE NUMERIC(19,6);
MONEDA VARCHAR(3);
BEGIN

IF (:TIPODOC ='FAC' OR :TIPODOC='ND') THEN
	SELECT "DocCur","DocRate" INTO MONEDA,DOCRATE
	FROM OINV 
	WHERE "DocEntry"= :DOCENTRY;
ELSE
	SELECT "DocCur","DocRate" INTO MONEDA,DOCRATE
	FROM ORIN 
	WHERE "DocEntry"= :DOCENTRY;
end if;
	
IF (:MONEDA <> 'USD') THEN
	DOCRATE :=1;
END IF;
	
IF (:TIPODOC ='FAC' OR :TIPODOC='ND') THEN
	SELECT 
		IFNULL(A."Quantity",0) "CANTIDAD",
		IFNULL(A."ItemCode",'N/A') "CODIGO_PRODUCTO",
		IFNULL(A."Dscription",'N/A') "DESCRIPCION_PRODUCTO",
		IFNULL(A."GTotal",0) "MONTO_BRUTO",
		(IFNULL(A."Price",0) * :DOCRATE) "PRECIO_UNITARIO",
		A."TaxCode" "TIPO_IMPUESTO",
		CASE A."TaxCode" WHEN 'EXE' THEN A."GTotal"  ELSE 0 END AS "IMPORTE_EXENTO",
		IFNULL(A."GTotal",0)  "IMPORTE_NETO_GRAVADO",
		IFNULL(A."GTotal",0)  "TOTAL_OPERACION",
		'0.00000' "MONTO_DESCUENTO",
		--ISNULL(C.SalUnitMsr,'N/D') UNIDAD_MEDIDA,
		'UND' UNIDAD_MEDIDA,
		IFNULL(A."VatSum",0) "IMPUESTO",
		B."DocType" "TIPO_DOC",
		'0.0000' "IMPORTE_OTROS_IMPUESTOS",
		'0.0000' "TOTAL_DESCUENTO_LINEA"
	FROM "INV1" A
	INNER JOIN "OINV" B
	ON A."DocEntry"  = B."DocEntry" 
	INNER JOIN "OITM" C
	ON A."ItemCode" =C."ItemCode" 
	WHERE A."DocEntry" = :DOCENTRY;
ELSE
	SELECT 
		IFNULL(A."Quantity",0) "CANTIDAD",
		IFNULL(A."ItemCode",'N/A') "CODIGO_PRODUCTO",
		IFNULL(A."Dscription",'N/A') "DESCRIPCION_PRODUCTO",
		IFNULL(A."GTotal",0) "MONTO_BRUTO",
		(IFNULL(A."Price",0)  * :DOCRATE) "PRECIO_UNITARIO",
		A."TaxCode" "TIPO_IMPUESTO",
		CASE A."TaxCode" WHEN 'EXE' THEN A."GTotal"  ELSE 0 END "IMPORTE_EXENTO",
		IFNULL(A."GTotal",0)  "IMPORTE_NETO_GRAVADO",
		IFNULL(A."GTotal",0)  "TOTAL_OPERACION",
		'0.00000' "MONTO_DESCUENTO",
		--ISNULL(C.SalUnitMsr,'N/D') UNIDAD_MEDIDA,
		'UND' "UNIDAD_MEDIDA",
		IFNULL(A."VatSum",0) "IMPUESTO",
		B."DocType" "TIPO_DOC",
		'0.0000' "IMPORTE_OTROS_IMPUESTOS",
		'0.0000' "TOTAL_DESCUENTO_LINEA"
	FROM "RIN1" A
	INNER JOIN "OINV" B
	ON A."DocEntry"  = B."DocEntry" 
	INNER JOIN OITM C
	ON A."ItemCode" =C."ItemCode" 
	WHERE A."DocEntry" = :DOCENTRY;
END IF;
END;