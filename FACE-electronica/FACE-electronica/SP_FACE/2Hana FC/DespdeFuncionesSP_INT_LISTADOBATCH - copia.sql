CREATE procedure SP_INT_LISTADOBATCH 
(in 
Serie int,
FechaIni  nvarchar(10),
FechaFin  nvarchar(10))
AS
BEGIN

IF (:Serie <> 0) THEN 
SELECT 
case IFNULL("U_ESTADO_FACE",'P') when 'P' then 'Pendiente' when 'R' then 'Rechazado' when 'A' then 'Autorizado' end AS "Estado",
"DocEntry" AS "Correlativo", 
"TipoDocumento" ,
"SeriesName" AS "Serie", 
"DocNum" AS "No. Documento",
"FechaDocumento",
"CardName" AS "Cliente",
"DocTotal" as "Total Documento"
,case (SELECT UFN_ESTADODOCUMENTO("DocEntry") from dummy) when 'A' then 'Anulado' else 'Vigente' end AS "Estado del Documento"  
FROM "_SYS_BIC"."AddonFACE/BATCH1" where IFNULL("U_ESTADO_FACE",'P') in ('P','R') and "DocDate" between :FechaIni and  :FechaFin and "Series" = :Serie 
union
SELECT 
case IFNULL("U_ESTADO_FACE",'P') when 'P' then 'Pendiente' when 'R' then 'Rechazado' when 'A' then 'Autorizado' end AS "Estado del Documento",
"DocEntry" AS "Correlativo", 
"TipoDocumento" ,
"SeriesName" AS "Serie", 
"DocNum" AS "No. Documento",
"FechaDocumento",
"CardName" AS "Cliente",
"DocTotal" as "Total Documento"
,"DocStatus" AS "Estado del Documento"   
FROM "_SYS_BIC"."AddonFACE/BATCH2" where IFNULL("U_ESTADO_FACE",'P') in ('P','R') and "DocDate" between :FechaIni and  :FechaFin and "Series" = :Serie 
order by "Serie", "Correlativo";
else 
SELECT 
case IFNULL("U_ESTADO_FACE",'P') when 'P' then 'Pendiente' when 'R' then 'Rechazado' when 'A' then 'Autorizado' end AS "Estado",
"DocEntry" AS "Correlativo", 
"TipoDocumento" ,
"SeriesName" AS "Serie", 
"DocNum" AS "No. Documento",
"FechaDocumento",
"CardName" AS "Cliente",
"DocTotal" as "Total Documento"
,case (SELECT UFN_ESTADODOCUMENTO("DocEntry") from dummy) when 'A' then 'Anulado' else 'Vigente' end AS "Estado del Documento"  
FROM "_SYS_BIC"."AddonFACE/BATCH1" where IFNULL("U_ESTADO_FACE",'P') in ('P','R') and "DocDate" between :FechaIni and  :FechaFin and "Series" in (select "U_SERIE" from "@FACE_RESOLUCION" where "U_ES_BATCH"='Y')
union 
select 
case IFNULL("U_ESTADO_FACE",'P') when 'P' then 'Pendiente' when 'R' then 'Rechazado' when 'A' then 'Autorizado' end AS "Estado del Documento",
"DocEntry" AS "Correlativo", 
"TipoDocumento" ,
"SeriesName" AS "Serie", 
"DocNum" AS "No. Documento",
"FechaDocumento",
"CardName" AS "Cliente",
"DocTotal" as "Total Documento"
,"DocStatus" AS "Estado del Documento"   
FROM "_SYS_BIC"."AddonFACE/BATCH2" where IFNULL("U_ESTADO_FACE",'P') in ('P','R') and "DocDate" between :FechaIni and  :FechaFin and "Series" in (select "U_SERIE" from "@FACE_RESOLUCION" where "U_ES_BATCH"='Y')
	order by "Serie", "Correlativo";
END IF;
END;