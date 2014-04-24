
BEGIN;


DROP TABLE IF EXISTS protocol;

CREATE TABLE protocol (
    objectId      varchar(100)  PRIMARY KEY,
    pName         varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS step;

CREATE TABLE step (
    objectId    ivarchar(100)   PRIMARY KEY,
    orderNumber integer         NOT NULL,
    protocolId	varchar(100)    NOT NULL,
    description	varchar(200)
);
   
DROP TABLE IF EXISTS textBlock;

CREATE TABLE textBlock (
    objectId        varchar(100)    PRIMARY KEY,
    printable       BIT             NOT NULL,
    orderNumber      integer         NOT NULL,
    content         varchar(140),
    title           varchar(100),
    stepId          varchar(100)    NOT NULL
);

DROP TABLE IF EXISTS calculator;

CREATE TABLE calculator(
    objectId        varchar(100)  PRIMARY KEY,
    orderNumber      integer         NOT NULL,
    stepId          varchar(100)  NOT NULL
);

DROP TABLE IF EXISTS link;

CREATE TABLE link (
    objectId       varchar(100)     PRIMARY KEY,
    url            varchar(100)     NOT NULL,
    label	       varchar(100)     NOT NULL,
    orderNumber    integer         NOT NULL,
    stepId         varchar(100)     NOT NULL
);

DROP TABLE IF EXISTS form;

CREATE TABLE form(
    objectId        varchar(100)  PRIMARY KEY,
    label           varchar(100)  NOT NULL,
    orderNumber      integer      NOT NULL,
    stepID          varchar(100)  NOT NULL
);

DROP TABLE IF EXISTS formSelection;

CREATE TABLE formSelection(
    objectId    varchar(100)    PRIMARY KEY,
    choiceA		varchar(1)      NOT NULL,
    choiceB		varchar(1)      NOT NULL,
    label		varchar(20)     NOT NULL,
    orderNumber    integer         NOT NULL,
    formId      varchar(100)    NOT NULL
);

DROP TABLE IF EXISTS formNumber;

CREATE TABLE formNumber(
    objectId        varchar(100)    PRIMARY KEY,
    defaultValue	integer         NOT NULL,
    minValue		integer         NOT NULL,
    maxValue		integer         NOT NULL,
    label           varchar(50)     NOT NULL,
    orderNumber     integer         NOT NULL,
    formId          varchar(100)    NOT NULL
);

DROP TABLE IF EXIST formAlgorithm;

CREATE TABLE formAlgorithm(
    objectId        varchar(100)    PRIMARY KEY,
    algOutput       integer         NOT NULL,
    resultOne       varchar(100)    NOT NULL,
    resultTwo       varchar(100)    NOT NULL,
    formId          varchar(100)    NOT NULL
);

COMMIT;