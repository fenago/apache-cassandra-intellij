<img align="right" src="https://raw.githubusercontent.com/fenago/apache-cassandra-intellij/master/md_files/logo-small.png">

#### TRACING

The `TRACING` command is a toggle that allows the tracing
functionality to be turned on:

```
TRACING ON
Now Tracing is enabled

TRACING
Tracing is currently enabled. Use TRACING OFF to disable
```
 

Tracing is useful in that it can show why particular queries may be
running slowly. A tracing report allows you to view things about a
query, such as the following:

-   Nodes contacted
-   Number of SSTables read
-   Number of tombstones encountered
-   How long the query took to run

