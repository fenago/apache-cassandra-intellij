import com.datastax.driver.core.*;

import java.time.Instant;
import java.time.ZoneId;
import java.util.Date;
import java.util.UUID;

public class CassandraV3Tutorial {

    private final static String KEYSPACE_NAME = "example_keyspace";
    private final static String REPLICATION_STRATEGY = "SimpleStrategy";
    private final static int REPLICATION_FACTOR = 1;
    private final static String TABLE_NAME = "example_table";

    public static void main(String[] args) {

        // Setup a cluster to your local instance of Cassandra
        Cluster cluster = Cluster.builder()
                .addContactPoint("localhost")
                .withPort(9042)
                .build();

        // Create a session to communicate with Cassandra
        Session session = cluster.connect();

        // Create a new Keyspace (database) in Cassandra
        String createKeyspace = String.format(
                "CREATE KEYSPACE IF NOT EXISTS %s WITH replication = " +
                        "{'class':'%s','replication_factor':%s};",
                KEYSPACE_NAME,
                REPLICATION_STRATEGY,
                REPLICATION_FACTOR
        );
        session.execute(createKeyspace);

        // Create a new table in our Keyspace
        String createTable = String.format(
                "CREATE TABLE IF NOT EXISTS %s.%s " + "" +
                        "(id uuid, timestamp timestamp, value double, " +
                        "PRIMARY KEY (id, timestamp)) " +
                        "WITH CLUSTERING ORDER BY (timestamp ASC);",
                KEYSPACE_NAME,
                TABLE_NAME
        );
        session.execute(createTable);

        // Create an insert statement to add a new item to our table
        PreparedStatement insertPrepared = session.prepare(String.format(
                "INSERT INTO %s.%s (id, timestamp, value) values (?, ?, ?)",
                KEYSPACE_NAME,
                TABLE_NAME
        ));

        // Some example data to insert
        UUID id = UUID.fromString("1e4d26ed-922a-4bd2-85cb-6357b202eda8");
        Date timestamp = Date.from(Instant.parse("2018-01-01T01:01:01.000Z"));
        double value = 123.45;

        // Bind the data to the insert statement and execute it
        BoundStatement insertBound = insertPrepared.bind(id, timestamp, value);
        session.execute(insertBound);

        // Create a select statement to retrieve the item we just inserted
        PreparedStatement selectPrepared = session.prepare(String.format(
                "SELECT id, timestamp, value FROM %s.%s WHERE id = ? AND timestamp >= ? AND  timestamp <= ?",
                KEYSPACE_NAME,
                TABLE_NAME));

        // Create a time range for the query
        Date startTime = Date.from(Instant.parse("2018-01-01T01:00:00.000Z"));
        Date endTime = Date.from(Instant.parse("2018-01-01T01:02:00.000Z"));

        // Bind the id to the select statement and execute it
        BoundStatement selectBound = selectPrepared.bind(id, startTime, endTime);
        ResultSet resultSet = session.execute(selectBound);

        // Print the retrieved data
        resultSet.forEach(row -> System.out.println(
                String.format("Id: %s, Timestamp: %s, Value: %s",
                row.getUUID("id"),
                row.getTimestamp("timestamp").toInstant().atZone(ZoneId.of("UTC")),
                row.getDouble("value"))));

        // Close session and disconnect from cluster
        session.close();
        cluster.close();
    }
}
