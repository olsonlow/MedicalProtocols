
BEGIN;


DROP TABLE IF EXISTS protocol;

CREATE TABLE protocol (
    id                  integer      NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId            integer      NOT NULL,
    pName               varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS step;

CREATE TABLE step (
    id          integer     NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId    integer      NOT NULL,
    stepNumber 	integer 	NOT NULL,
    protocolId	integer     NOT NULL,
    description	varchar(200)
);
   
DROP TABLE IF EXISTS textBlock;

CREATE TABLE textBlock (
    id              integer     NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId        integer     NOT NULL,
    printable       BIT 		NOT NULL,
    title	       varchar(100)	NOT NULL,
    stepId         integer      NOT NULL
);

DROP TABLE IF EXISTS calculator;

CREATE TABLE calculator(
    id              integer     NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId        integer      NOT NULL,
    stepId          integer     NOT NULL
);

DROP TABLE IF EXISTS link;

CREATE TABLE link (
    id              integer	NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId            integer      NOT NULL,
    url             varchar(100)      NOT NULL,
    printable       BIT 		NOT NULL,
    label	       varchar(100)	NOT NULL,
    stepId         integer      NOT NULL
);

DROP TABLE IF EXISTS form;

CREATE TABLE form(
    id              integer     NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId        integer      NOT NULL,
    stepID          integer     NOT NULL
);

DROP TABLE IF EXISTS formSelection;

CREATE TABLE formSelection(
    id          integer         NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId    integer      NOT NULL,
    choiceA		varchar(1)      NOT NULL,
    choiceB		varchar(1)      NOT NULL,
    label		varchar(20)     NOT NULL,
    formId      integer         NOT NULL
);

DROP TABLE IF EXISTS formNumber;

CREATE TABLE formNumber(
    id              integer     NOT NULL PRIMARY KEY AUTOINCREMENT,
    objectId        integer      NOT NULL,
    defaultValue	integer		NOT NULL,
    minValue		integer		NOT NULL,
    maxValue		integer		NOT NULL,
    label 		varchar(50)     NOT NULL,
    formId          integer     NOT NULL
);

COMMIT;