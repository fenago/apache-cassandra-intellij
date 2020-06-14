USE fenago;

CREATE TABLE table03 (
 rowkey ascii,
 setfield set<text>,
 listfield list<text>,
 mapfield map<text, text>,
 PRIMARY KEY (rowkey)
);

INSERT INTO table03
 (rowkey, setfield, listfield, mapfield)
 VALUES
 ('1', {'Lemon','Orange','Apple'},
  ['Lemon','Orange','Apple'],
  {'fruit1':'Apple','fruit3':'Orange','fruit2':'Lemon'});
  
SELECT * FROM table03;
