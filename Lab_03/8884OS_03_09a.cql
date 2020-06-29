CREATE TABLE table02 (
  rowkey ascii,
  counterfield counter,
  PRIMARY KEY (rowkey)
);

UPDATE table02 SET counterfield = counterfield + 1
  WHERE rowkey = '1';

SELECT * FROM table02;
