USE fenago;

CREATE TABLE dayquote01 (
  symbol varchar PRIMARY KEY,
  exchange varchar,
  price_time timestamp,
  open_price float,
  high_price float,
  low_price float,
  close_price float,
  volume double
);
