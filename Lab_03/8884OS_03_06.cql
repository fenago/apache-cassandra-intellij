USE fenago;

UPDATE table01 SET inetfield = '2001:0db8:85a3:0042:1000:8a2e:0370:7334' WHERE rowkey = '1';

SELECT inetfield FROM table01;
