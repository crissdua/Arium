CREATE  PROCEDURE [dbo].[SP_IT_DATOS_ENCABEZADO] @Docentry int,@Tipo char(3)
AS
		SET ARITHABORT ON
		 
		IF @Tipo='FAC' or @Tipo='ND'
		Select DISTINCT 
				isnull([@FACE_RESOLUCION].U_DISPOSITIVO,'N/D') DISPOSITIVO,
				DBO.ESTADO_DOC(@Docentry)   ESTADO_DOCUMENTO,
				CASE OINV.DOCCUR WHEN 'QTZ' THEN 'GTQ' ELSE 'USD' END CODIGO_MONEDA,
				DBO.TIPODOC_GFACE(isnull([@FACE_RESOLUCION].U_TIPO_DOC,'N/D')) TIPO_DOCUMENTO,
				CASE oinv.LicTradNum
                       When '000000000C.F.' Then 'C.F'
                       When '0000000000C/F' Then 'C.F'
                       Else SUBSTRING(replace(isnull(oinv.LicTradNum,'C.F'),'-',''), PATINDEX('%[^0 ]%', replace(isnull(oinv.LicTradNum,'C.F'),'-','') + ' '), LEN(replace(isnull(oinv.LicTradNum,'C.F'),'-','')))
                End NIT_COMPRADOR,
				isnull(dbo.ufn_ValorParametro('NIT'),'N/D') NIT_VENDEDOR,
				ISNULL(NNM1.REMARK,NNM1.SeriesName) SERIE_AUTORIZADA,
				oinv.doctotal  TOTAL_DOCUMENTO,
				CONVERT(VARCHAR,OINV.DocDate,126) FECHA_DOCUMENTO,
				ISNULL(RIN1.DOCDATE,getdate()) FECHA_ANULACION,
				ISNULL(OINV.Comments,'N/D') OBSERVACIONES,
				ISNULL(OCRD.phone1,'N/D') TELEFONO_COMPRADOR,
				0.0 IMPORTE_DESCUENTO,
				DBO.TOTAL_EXENTO(@Docentry,@Tipo) TOTAL_EXENTO,
				OINV.DocTotal IMPORTE_NETO_GRAVADO,
				OINV.VatSum DETALLE_IMPUESTO_IVA,
				isnull(oinv.DocRate,0) TIPO_CAMBIO,
				ISNULL(OINV.[Address], 'CIUDAD') DIRECCION_COMPRADOR,
				--'CIUDAD' DIRECCION_COMPRADOR,
				0.0 IMPORTE_OTROS_IMPUESTOS,
				isnull([@FACE_RESOLUCION].U_RESOLUCION,'N/D') NUMERO_RESOLUCION,
				isnull(ocrd.city,'Guatemala') MUNICIPIO_COMPRADOR,
				isnull(ocrd.County,'Guatemala') DEPARTAMENTO_COMPRADOR,
				isnull(oinv.CardName,'Consumidor Final')  NOMBRE_COMPRADOR,
				isnull(dbo.ufn_ValorParametro('NOMC'),'N/D') NOMBRE_VENDEDOR,
				--CASE WHEN OINV.SERIES IN(84,371) THEN 'Guatemala' ELSE 'Mazatenando' end  MUNICIPIO_VENDEDOR,
				--CASE WHEN OINV.SERIES NOT IN(84,371) THEN 'Guatemala' ELSE 'Suchitepequez' end DEPARTAMENTO_VENDEDOR,
				isnull(convert(varchar,[@FACE_RESOLUCION].U_MUNI_SUCURSAL),'Guatemala') MUNICIPIO_VENDEDOR,
				isnull(convert(varchar,[@FACE_RESOLUCION].U_DEPTO_SUCURSAL),'Guatemala') DEPARTAMENTO_VENDEDOR,
				isnull(dbo.ufn_ValorParametro('DIRE'),'N/D') DIRECCION_VENDEDOR,
				replace(CONVERT(varchar,[@FACE_RESOLUCION].U_FECHA_AUTORIZACION,111),'/','-') FECHA_RESOLUCION,
				'RET_DEFINITIVA' REGIMEN_ISR,
				OINV.DocTotal - OINV.VatSum IMPORTE_BRUTO,
				'12521337' NIT_GFACE,
				isnull([@FACE_RESOLUCION].U_SUCURSAL,'N/D') CODIGO_SUCURSAL,
				CASE ISNULL(OCRD.E_MAIL,'N/D') WHEN 'N/D' THEN 'N/D' ELSE DBO.OBTIENE_CORREO(OCRD.E_MAIL) END CORREO_COMPRADOR,
				'N/D' DESCRIPCION_OTROS_IMPUESTOS,
				CASE OINV.SERIES WHEN 29 THEN OINV.DocNum ELSE DBO.CORRIGEDOC_NUM(OINV.DocNum) END NUMERO_DOCUMENTO,
				OINV.DocType TIPO_DOC,
				'' PERSONALIZADO_1,
				'' PERSONALIZADO_2,
				'' PERSONALIZADO_3,
				'' PERSONALIZADO_4,
				'' PERSONALIZADO_5,
				'' PERSONALIZADO_6,
				'' PERSONALIZADO_7,
				'' PERSONALIZADO_8,
				'' PERSONALIZADO_9,
				'' PERSONALIZADO_10,
				'' PERSONALIZADO_11,
				'' PERSONALIZADO_12,
				'' PERSONALIZADO_13,
				'' PERSONALIZADO_14,
				'' PERSONALIZADO_15,
				'' PERSONALIZADO_16,
				'' PERSONALIZADO_17,
				'' PERSONALIZADO_18,
				'' PERSONALIZADO_19,
				'' PERSONALIZADO_20					
			from OINV 
				left outer join [@FACE_RESOLUCION]
				on [@FACE_RESOLUCION].U_SERIE=OINV.series
				left outer join  OCRD 
				on ocrd.CardCode =oinv.CardCode
				INNER JOIN NNM1 on oinv.Series =NNM1.Series 
				LEFT OUTER JOIN CRD1
				ON OCRD.CARDCODE=CRD1.CARDCODE
				LEFT OUTER JOIN RIN1
				ON OINV.DocNum =RIN1.BaseDocNum
				AND RIN1. BaseType=13
			where OINV.DocEntry =@Docentry
	IF @Tipo='NC'
			Select DISTINCT 
				isnull([@FACE_RESOLUCION].U_DISPOSITIVO,'N/D') DISPOSITIVO,
				'ACTIVO' ESTADO_DOCUMENTO,
				CASE OINV.DOCCUR WHEN 'QTZ' THEN 'GTQ' ELSE 'USD' END CODIGO_MONEDA,
				DBO.TIPODOC_GFACE(isnull([@FACE_RESOLUCION].U_TIPO_DOC,'N/D')) TIPO_DOCUMENTO,
                CASE oinv.LicTradNum
                       When '000000000C.F.' Then 'C.F'
                       When '0000000000C/F' Then 'C.F'
                       Else SUBSTRING(replace(isnull(oinv.LicTradNum,'C.F'),'-',''), PATINDEX('%[^0 ]%', replace(isnull(oinv.LicTradNum,'C.F'),'-','') + ' '), LEN(replace(isnull(oinv.LicTradNum,'C.F'),'-','')))
                End NIT_COMPRADOR,
				isnull(dbo.ufn_ValorParametro('NIT'),'N/D') NIT_VENDEDOR,
				ISNULL(NNM1.REMARK,NNM1.SeriesName) SERIE_AUTORIZADA,
				oinv.doctotal  TOTAL_DOCUMENTO,
				CONVERT(VARCHAR,OINV.DocDate,126) FECHA_DOCUMENTO,
				getdate() FECHA_ANULACION,
				ISNULL(OINV.Comments,'N/D') OBSERVACIONES,
				ISNULL(OCRD.phone1,'N/D') TELEFONO_COMPRADOR,
				0.0 IMPORTE_DESCUENTO,
				DBO.TOTAL_EXENTO(@Docentry,@Tipo) TOTAL_EXENTO,
				OINV.DocTotal IMPORTE_NETO_GRAVADO,
				OINV.VatSum DETALLE_IMPUESTO_IVA,
				isnull(oinv.DocRate,0) TIPO_CAMBIO,
				ISNULL(OINV.[Address], 'CIUDAD') DIRECCION_COMPRADOR,
				0.0 IMPORTE_OTROS_IMPUESTOS,
				isnull([@FACE_RESOLUCION].U_RESOLUCION,'N/D') NUMERO_RESOLUCION,
				isnull(ocrd.city,'Guatemala') MUNICIPIO_COMPRADOR,
				isnull(ocrd.County,'Guatemala') DEPARTAMENTO_COMPRADOR,
				isnull(oinv.CardName,'Consumidor Final')  NOMBRE_COMPRADOR,
				isnull(dbo.ufn_ValorParametro('NOMC'),'N/D') NOMBRE_VENDEDOR,
				isnull(convert(varchar,[@FACE_RESOLUCION].U_MUNI_SUCURSAL),'Guatemala') MUNICIPIO_VENDEDOR,
				isnull(convert(varchar,[@FACE_RESOLUCION].U_DEPTO_SUCURSAL),'Guatemala') DEPARTAMENTO_VENDEDOR,
				isnull(dbo.ufn_ValorParametro('DIRE'),'N/D') DIRECCION_VENDEDOR,
				replace(CONVERT(varchar,[@FACE_RESOLUCION].U_FECHA_AUTORIZACION,111),'/','-') FECHA_RESOLUCION,
				'RET_DEFINITIVA' REGIMEN_ISR,
				OINV.DocTotal - OINV.VatSum IMPORTE_BRUTO,
				'12521337' NIT_GFACE,
				isnull([@FACE_RESOLUCION].U_SUCURSAL,'N/D') CODIGO_SUCURSAL,
				CASE ISNULL(OCRD.E_MAIL,'N/D') WHEN 'N/D' THEN 'N/D' ELSE DBO.OBTIENE_CORREO(OCRD.E_MAIL) END CORREO_COMPRADOR,
				'N/D' DESCRIPCION_OTROS_IMPUESTOS,
				CASE OINV.SERIES WHEN 29 THEN OINV.DocNum ELSE DBO.CORRIGEDOC_NUM(OINV.DocNum) END NUMERO_DOCUMENTO,
				OINV.DocType TIPO_DOC,
				'' PERSONALIZADO_1,
				'' PERSONALIZADO_2,
				'' PERSONALIZADO_3,
				'' PERSONALIZADO_4,
				'' PERSONALIZADO_5,
				'' PERSONALIZADO_6,
				'' PERSONALIZADO_7,
				'' PERSONALIZADO_8,
				'' PERSONALIZADO_9,
				'' PERSONALIZADO_10,
				'' PERSONALIZADO_11,
				'' PERSONALIZADO_12,
				'' PERSONALIZADO_13,
				'' PERSONALIZADO_14,
				'' PERSONALIZADO_15,
				'' PERSONALIZADO_16,
				'' PERSONALIZADO_17,
				'' PERSONALIZADO_18,
				'' PERSONALIZADO_19,
				'' PERSONALIZADO_20						
			from ORIN OINV 
				left outer join [@FACE_RESOLUCION]
				on [@FACE_RESOLUCION].U_SERIE=OINV.series
				left outer join  OCRD 
				on ocrd.CardCode =oinv.CardCode
				INNER JOIN NNM1 on oinv.Series =NNM1.Series 
				LEFT OUTER JOIN CRD1
				ON OCRD.CARDCODE=CRD1.CARDCODE
			where OINV.DocEntry =@Docentry