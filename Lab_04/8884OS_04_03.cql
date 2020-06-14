USE fenago;

INSERT INTO dayquote01
  (exchange, symbol, price_time, open_price,
   high_price, low_price, close_price, volume)
  values
  ('SEHK', '0001.HK', '2014-06-01 10:00:00', 11.1,
   12.2, 10.0, 10.9, 1000000.0);
 
INSERT INTO dayquote01
  (exchange, symbol, price_time, open_price,
   high_price, low_price, close_price, volume)
  values
  ('SEHK', '0001.HK', '2014-05-31 10:00:00', 11.0,
   12.0, 10.0, 11, 500000.0);

SELECT * FROM dayquote01;