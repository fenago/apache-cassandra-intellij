CREATE TABLE dayquote06 (
  symbol varchar,
  exchange varchar,
  sector varchar,
  price_time timestamp,
  quote_date varchar,
  open_price float,
  high_price float,
  low_price float,
  close_price float,
  volume double,
  PRIMARY KEY ((exchange, quote_date), symbol, price_time)
);

INSERT INTO dayquote06
  (exchange, symbol, sector, price_time, open_price,
   high_price, low_price, close_price, volume, quote_date)
  values
  ('SEHK', '0001.HK', 'Properties', '2014-06-01 10:00:00', 11.1,
   12.2, 10.0, 10.9, 1000000.0, '20140601');
 
INSERT INTO dayquote06
  (exchange, symbol, sector, price_time, open_price,
   high_price, low_price, close_price, volume, quote_date)
  values
  ('SEHK', '0002.HK', 'Utilities', '2014-06-01 10:05:00', 11.0,
   12.0, 10.0, 11, 500000.0, '20140601');
