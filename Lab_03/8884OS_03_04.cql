INSERT INTO table01
 ( rowkey, asciifield, bigintfield, blobfield, booleanfield,
   decimalfield, doublefield, floatfield, inetfield, intfield,
   textfield, timestampfield, timeuuidfield, uuidfield,
   varcharfield, varintfield)
 VALUES
 ( '1', 'ABC', 1000000000, textAsBlob('ABC'), True,
   1.0, 1.123456789, 1.123456, '192.168.0.1', 1,
   'ABC', '2014-05-01 01:02:03', now(), uuid(),
   'ABC', 1);
