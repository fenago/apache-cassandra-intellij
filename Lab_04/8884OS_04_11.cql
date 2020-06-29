CREATE TABLE dayquote05 (
  symbol varchar,
  exchange varchar,
  price_time timestamp,
  quote_date varchar,
  open_price float,
  high_price float,
  low_price float,
  close_price float,
  volume double,
  PRIMARY KEY ((exchange, quote_date), symbol, price_time)
);