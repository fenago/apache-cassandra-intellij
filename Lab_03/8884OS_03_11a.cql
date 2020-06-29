CREATE TYPE contact (
 facebook text,
 twitter text,
 email text
);

CREATE TABLE table04 (
 rowkey ascii PRIMARY KEY,
 contactfield frozen<contact>,
 tuplefield frozen<tuple<int, text>>
);

INSERT INTO table04 (rowkey, contactfield, tuplefield)
 VALUES ('a', {facebook:'b',twitter:'c',email:'d@d.com'},
 (1,'e'));
 
SELECT contactfield, contactfield.facebook, tuplefield FROM table04;
