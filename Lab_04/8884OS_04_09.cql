CREATE TABLE dayquote04 (
  symbol varchar,
  exchange varchar,
  price_time timestamp,
  open_price float,
  high_price float,
  low_price float,
  close_price float,
  volume double,
  PRIMARY KEY ((exchange, symbol), price_time)
);

INSERT INTO dayquote04
  (exchange, symbol, price_time, open_price,
   high_price, low_price, close_price, volume)
  values
  ('SEHK', '0001.HK', '2014-06-01 10:00:00', 11.1,
   12.2, 10.0, 10.9, 1000000.0);
 
INSERT INTO dayquote04
  (exchange, symbol, price_time, open_price,
   high_price, low_price, close_price, volume)
  values
  ('SEHK', '0002.HK', '2014-06-01 10:05:00', 11.0,
   12.0, 10.0, 11, 500000.0);
