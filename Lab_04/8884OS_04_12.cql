USE fenago;

SELECT symbol FROM dayquote04
 WHERE TOKEN(exchange,symbol) < TOKEN('SEHK','0002.HK');
