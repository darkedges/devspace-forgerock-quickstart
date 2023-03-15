--liquibase formatted sql
--changeset frim:6.5.2_audit endDelimiter:; splitStatements:true

-- DROP TABLE auditaccess CASCADE CONSTRAINTS;

-- -----------------------------------------------------
-- Table openidm.auditaccess
-- -----------------------------------------------------
CREATE TABLE auditaccess (
  objectid VARCHAR2(56 CHAR) NOT NULL,
  activitydate VARCHAR2(29 CHAR) NOT NULL,
  eventname VARCHAR2(255 CHAR),
  transactionid VARCHAR2(255 CHAR) NOT NULL,
  userid VARCHAR2(255 CHAR),
  trackingids CLOB,
  server_ip VARCHAR2(40 CHAR),
  server_port VARCHAR2(5 CHAR),
  client_ip VARCHAR2(40 CHAR),
  client_port VARCHAR2(5 CHAR),
  request_protocol VARCHAR2(255 CHAR) NULL ,
  request_operation VARCHAR2(255 CHAR) NULL ,
  request_detail CLOB NULL ,
  http_request_secure VARCHAR2(255 CHAR) NULL ,
  http_request_method VARCHAR2(255 CHAR) NULL ,
  http_request_path VARCHAR2(255 CHAR) NULL ,
  http_request_queryparameters CLOB NULL ,
  http_request_headers CLOB NULL ,
  http_request_cookies CLOB NULL ,
  http_response_headers CLOB NULL ,
  response_status VARCHAR2(255 CHAR) NULL ,
  response_statuscode VARCHAR2(255 CHAR) NULL ,
  response_elapsedtime VARCHAR2(255 CHAR) NULL ,
  response_elapsedtimeunits VARCHAR2(255 CHAR) NULL ,
  response_detail CLOB NULL ,
  roles CLOB NULL
);


COMMENT ON COLUMN auditaccess.activitydate IS 'Date format: 2011-09-09T14:58:17.654+02:00'
;

ALTER TABLE auditaccess
ADD CONSTRAINT PRIMARY_OBJECTID PRIMARY KEY
(
  objectid
)
ENABLE
;

-- DROP TABLE auditauthentication CASCADE CONSTRAINTS;

-- -----------------------------------------------------
-- Table openidm.auditauthentication
-- -----------------------------------------------------
CREATE TABLE auditauthentication (
  objectid VARCHAR2(56 CHAR) NOT NULL,
  transactionid VARCHAR2(255 CHAR) NOT NULL,
  activitydate VARCHAR2(29 CHAR) NOT NULL,
  userid VARCHAR2(255 CHAR),
  eventname VARCHAR2(50 CHAR),
  provider VARCHAR2(255 CHAR),
  method VARCHAR2(25 CHAR),
  result VARCHAR2(255 CHAR),
  principals CLOB,
  context CLOB,
  entries CLOB,
  trackingids CLOB
);

COMMENT ON COLUMN auditauthentication.activitydate IS 'Date format: 2011-09-09T14:58:17.654+02:00'
;

ALTER TABLE auditauthentication
ADD CONSTRAINT pk_auditauthentication PRIMARY KEY
(
  objectid
)
ENABLE
;


-- DROP TABLE auditconfig CASCADE CONSTRAINTS;

-- -----------------------------------------------------
-- Table openidm.auditconfig
-- -----------------------------------------------------
CREATE TABLE auditconfig (
  objectid VARCHAR2(56 CHAR) NOT NULL,
  activitydate VARCHAR2(29 CHAR) NOT NULL,
  eventname VARCHAR2(255 CHAR),
  transactionid VARCHAR2(255 CHAR) NOT NULL,
  userid VARCHAR2(255 CHAR),
  trackingids CLOB,
  runas VARCHAR2(255 CHAR),
  configobjectid VARCHAR2(255 CHAR) NULL ,
  operation VARCHAR2(255 CHAR) NULL ,
  beforeObject CLOB,
  afterObject CLOB,
  changedfields CLOB,
  rev VARCHAR2(255 CHAR)
);


COMMENT ON COLUMN auditconfig.activitydate IS 'Date format: 2011-09-09T14:58:17.654+02:00'
;

ALTER TABLE auditconfig
ADD CONSTRAINT pk_auditconfig PRIMARY KEY
(
  objectid
)
ENABLE
;



-- DROP TABLE auditactivity CASCADE CONSTRAINTS;

-- -----------------------------------------------------
-- Table openidm.auditactivity
-- -----------------------------------------------------
CREATE TABLE auditactivity (
  objectid VARCHAR2(56 CHAR) NOT NULL,
  activitydate VARCHAR2(29 CHAR) NOT NULL,
  eventname VARCHAR2(255 CHAR),
  transactionid VARCHAR2(255 CHAR) NOT NULL,
  userid VARCHAR2(255 CHAR),
  trackingids CLOB,
  runas VARCHAR2(255 CHAR),
  activityobjectid VARCHAR2(255 CHAR) NULL ,
  operation VARCHAR2(255 CHAR) NULL ,
  subjectbefore CLOB,
  subjectafter CLOB,
  changedfields CLOB,
  subjectrev VARCHAR2(255 CHAR),
  passwordchanged VARCHAR2(5 CHAR),
  message CLOB,
  provider VARCHAR2(255 CHAR) NULL,
  context VARCHAR2(25 CHAR) NULL,
  status VARCHAR2(20 CHAR)
);


COMMENT ON COLUMN auditactivity.activitydate IS 'Date format: 2011-09-09T14:58:17.654+02:00'
;

ALTER TABLE auditactivity
ADD CONSTRAINT pk_auditactivity PRIMARY KEY
(
  objectid
)
ENABLE
;

-- DROP TABLE auditrecon CASCADE CONSTRAINTS;

-- -----------------------------------------------------
-- Table openidm.auditrecon
-- -----------------------------------------------------
CREATE TABLE auditrecon (
  objectid VARCHAR2(56) NOT NULL,
  transactionid VARCHAR2(255) NOT NULL,
  activitydate VARCHAR2(29 CHAR) NOT NULL,
  eventname VARCHAR2(50 CHAR),
  userid VARCHAR2(255 CHAR),
  trackingids CLOB,
  activity VARCHAR2(24 CHAR),
  exceptiondetail CLOB,
  linkqualifier VARCHAR2(255 CHAR),
  mapping VARCHAR2(511 CHAR),
  message CLOB,
  messagedetail CLOB,
  situation VARCHAR2(24 CHAR),
  sourceobjectid VARCHAR2(511 CHAR),
  status VARCHAR2(20 CHAR),
  targetobjectid VARCHAR2(511 CHAR),
  reconciling VARCHAR2(12 CHAR),
  ambiguoustargetobjectids CLOB,
  reconaction VARCHAR2(36 CHAR),
  entrytype VARCHAR2(7 CHAR),
  reconid VARCHAR2(56 CHAR)
);


COMMENT ON COLUMN auditrecon.activitydate IS 'Date format: 2011-09-09T14:58:17.654+02:00'
;

ALTER TABLE auditrecon
ADD CONSTRAINT PRIMARY_1 PRIMARY KEY
(
  objectid
)
ENABLE
;

CREATE INDEX idx_auditrecon_reconid ON auditrecon
(
  reconid
)
;

CREATE INDEX idx_auditrecon_entrytype ON auditrecon
(
  entrytype
)
;

-- DROP TABLE auditsync CASCADE CONSTRAINTS;

-- -----------------------------------------------------
-- Table openidm.auditsync
-- -----------------------------------------------------
CREATE TABLE auditsync (
  objectid VARCHAR2(56) NOT NULL,
  transactionid VARCHAR2(255) NOT NULL,
  activitydate VARCHAR2(29 CHAR) NOT NULL,
  eventname VARCHAR2(50 CHAR),
  userid VARCHAR2(255 CHAR),
  trackingids CLOB,
  activity VARCHAR2(24 CHAR),
  exceptiondetail CLOB,
  linkqualifier VARCHAR2(255 CHAR),
  mapping VARCHAR2(511 CHAR),
  message CLOB,
  messagedetail CLOB,
  situation VARCHAR2(24 CHAR),
  sourceobjectid VARCHAR2(511 CHAR),
  status VARCHAR2(20 CHAR),
  targetobjectid VARCHAR2(511 CHAR)
);


COMMENT ON COLUMN auditsync.activitydate IS 'Date format: 2011-09-09T14:58:17.654+02:00'
;

ALTER TABLE auditsync
ADD CONSTRAINT PRIMARY_13 PRIMARY KEY
(
  objectid
)
ENABLE
;