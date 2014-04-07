
BEGIN;


DROP TABLE IF EXISTS protocol;

CREATE TABLE protocol (
    objectID	      varchar(20)	NOT NULL PRIMARY KEY,
    createdAt      date		NOT NULL,
    updatedAt      date		NOT NULL,
    pName	      varchar(50)	NOT NULL
);

DROP TABLE IF EXISTS step;

CREATE TABLE step (
    objectID		varchar(20)	NOT NULL PRIMARY KEY,
    stepNumber 	integer 	NOT NULL,
    updatedAt  	date		NOT NULL,
    createdAt  	date 		NOT NULL,
    protocolID	varchar(20)	NOT NULL,
    description	varchar(200),
    FOREIGN KEY (protocolID) REFERENCES protocol(objectID)
);
   
DROP TABLE IF EXISTS textBlock;

CREATE TABLE textBlock (
    objectID        varchar(20)	NOT NULL PRIMARY KEY,
    createdAt       date		NOT NULL,
    updatedAt       date		NOT NULL,
    printable       BIT 		NOT NULL,
    title	       varchar(100)	NOT NULL,
    stepID          varchar(20) NOT NULL,
    FOREIGN KEY (stepID) REFERENCES step(objectID)
);

DROP TABLE IF EXISTS calculator;

CREATE TABLE calculator(
    objectID		varchar(20)	NOT NULL PRIMARY KEY,
    createdAt       date		NOT NULL,
    updatedAt       date		NOT NULL,
    stepID          varchar(20) NOT NULL,
    FOREIGN KEY (stepID) REFERENCES step(objectID)
);

DROP TABLE IF EXISTS link;

CREATE TABLE link (
    objectID        varchar(20)	NOT NULL PRIMARY KEY,
    url             varchar(100)      NOT NULL,
    createdAt       date		NOT NULL,
    updatedAt       date		NOT NULL,
    printable       BIT 		NOT NULL,
    label	       varchar(100)	NOT NULL,
    stepID          varchar(20) NOT NULL,
    FOREIGN KEY (stepID) REFERENCES step(objectID)
);

DROP TABLE IF EXISTS form;

CREATE TABLE form(
    objectID		varchar(20)	NOT NULL PRIMARY KEY,
    createdAt       date		NOT NULL,
    updatedAt       date		NOT NULL,
    stepID          varchar(20) NOT NULL,
    FOREIGN KEY (stepID) REFERENCES step(objectID)
);

DROP TABLE IF EXISTS formSelection;

CREATE TABLE formSelection(
    objectID		varchar(20)	NOT NULL PRIMARY KEY,
    choiceA		varchar(1)      NOT NULL,
    choiceB		varchar(1)      NOT NULL,
    label		varchar(20)     NOT NULL,
    createdAt       date		NOT NULL,
    updatedAt       date		NOT NULL,
    formID          varchar(20) NOT NULL,
    FOREIGN KEY (formID) REFERENCES form(formID)
);

DROP TABLE IF EXISTS formNumber;

CREATE TABLE formNumber(
  objectID		varchar(20)     NOT NULL PRIMARY KEY,
    defaultValue	integer		NOT NULL,
    minValue		integer		NOT NULL,
    maxValue		integer		NOT NULL,
    label 		varchar(50)     NOT NULL,
    createdAt       date		NOT NULL,
    updatedAt       date		NOT NULL,
    formID          varchar(20) NOT NULL,
    FOREIGN KEY (formID) REFERENCES form(formID)
);

COMMIT;