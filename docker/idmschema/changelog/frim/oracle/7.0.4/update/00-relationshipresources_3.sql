--liquibase formatted sql
--changeset frim:7.0.4_update_00_3 endDelimiter:; splitStatements:true

INSERT
INTO
	frim.relationshipresources (
	    originresourcecollection,
	    originproperty,
	    refresourcecollection,
	    originfirst,
	    reverseproperty
	)
SELECT
	DISTINCT
	firstresourcecollection,
	firstpropertyname,
	secondresourcecollection,
	1,
	secondpropertyname
FROM
	frim.relationships r
WHERE
	r.firstpropertyname IS NOT NULL
	AND NOT EXISTS (
	SELECT
		1
	FROM
		frim.relationshipresources rr
	WHERE
		rr.originresourcecollection = r.firstresourcecollection AND
		rr.originproperty = r.firstpropertyname AND
		rr.refresourcecollection = r.secondresourcecollection AND
		rr.originfirst = 1)
UNION ALL
SELECT
	DISTINCT
	secondresourcecollection,
	secondpropertyname,
	firstresourcecollection,
	0,
	firstpropertyname
FROM
	frim.relationships r
WHERE
	r.secondpropertyname IS NOT NULL
	AND NOT EXISTS (
	SELECT
		1
	FROM
		frim.relationshipresources rr
	WHERE
		rr.originresourcecollection = r.secondresourcecollection AND
		rr.originproperty = r.secondpropertyname AND
		rr.refresourcecollection = r.firstresourcecollection AND
		rr.originfirst = 0);

-- -----------------------------------------------------
-- Drop temporary TRIGGER and SEQUENCE
-- -----------------------------------------------------
DROP TRIGGER trig_relationshipresources;
DROP SEQUENCE relationshipresources_id_seq;
