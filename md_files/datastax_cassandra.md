
Intro to DataStax Java Driver for Apache Cassandra
==================================================

​**1. Overview**

The DataStax Distribution of [Apache
Cassandra](https://www.baeldung.com/cassandra-with-java) is a
production-ready distributed database, compatible with open-source
Cassandra. It adds a few features that aren't available in the
open-source distribution, including monitoring, improved batch, and
streaming data processing.

DataStax also provides a Java client for its distribution of Apache
Cassandra. This driver is highly tunable and can take advantage of all
the extra features in the DataStax distribution, yet it's fully
compatible with the open-source version, too.

In this tutorial, we'll see **how to use the [DataStax Java Driver for
Apache Cassandra](https://github.com/datastax/java-driver)**to connect
to a Cassandra database and perform basic data manipulation.

​**2. Maven Dependency**

In order to use the DataStax Java Driver for Apache Cassandra, we need
to include it in our classpath.

With Maven, we simply have to add the [*java-driver-core*
dependency](https://search.maven.org/search?q=g:com.datastax.oss%20a:java-driver-core)
to our *pom.xml*:

    <dependency>    <groupId>com.datastax.oss</groupId>    <artifactId>java-driver-core</artifactId>    <version>4.1.0</version></dependency> <dependency>    <groupId>com.datastax.oss</groupId>    <artifactId>java-driver-query-builder</artifactId>    <version>4.1.0</version></dependency>

​**3. Using the DataStax Driver**

Now that we have the driver in place, let's see what we can do with it.

**3.1. Connect to the Database**

In order to get connected to the database, we'll create a *CqlSession*:

    CqlSession session = CqlSession.builder().build();

If we don't explicitly define any contact point, the builder will
default to *127.0.0.1:9042*.

Let's create a connector class, with some configurable parameters, to
build the *CqlSession*:

    public class CassandraConnector {     private CqlSession session;     public void connect(String node, Integer port, String dataCenter) {        CqlSessionBuilder builder = CqlSession.builder();        builder.addContactPoint(new InetSocketAddress(node, port));        builder.withLocalDatacenter(dataCenter);         session = builder.build();    }     public CqlSession getSession() {        return this.session;    }     public void close() {        session.close();    }}

**3.2. Create Keyspace**

Now that we have a connection to the database, we need to create our
keyspace. Let's start by writing a simple repository class for working
with our keyspace.

For this tutorial, **we'll use the *SimpleStrategy* replication strategy
with the number of replicas set to 1**:

    public class KeyspaceRepository {     public void createKeyspace(String keyspaceName, int numberOfReplicas) {        CreateKeyspace createKeyspace = SchemaBuilder.createKeyspace(keyspaceName)          .ifNotExists()          .withSimpleStrategy(numberOfReplicas);         session.execute(createKeyspace.build());    }     // ...}

Also, we can **start using the keyspace in the current session**:

    public class KeyspaceRepository {     //...     public void useKeyspace(String keyspace) {        session.execute("USE " + CqlIdentifier.fromCql(keyspace));    }}

**3.3. Create Table**

The driver provides statements to configure and execute queries in the
database. For example, **we can set the keyspace to use individually in
each statement**.

We'll define the *Video* model and create a table to represent it:

    public class Video {    private UUID id;    private String title;    private Instant creationDate;     // standard getters and setters}

Let's create our table, having the possibility to define the keyspace in
which we want to perform the query. We'll write a simple
*VideoRepository* class for working with our video data:

    public class VideoRepository {    private static final String TABLE_NAME = "videos";     public void createTable() {        createTable(null);    }     public void createTable(String keyspace) {        CreateTable createTable = SchemaBuilder.createTable(TABLE_NAME)          .withPartitionKey("video_id", DataTypes.UUID)          .withColumn("title", DataTypes.TEXT)          .withColumn("creation_date", DataTypes.TIMESTAMP);         executeStatement(createTable.build(), keyspace);    }     private ResultSet executeStatement(SimpleStatement statement, String keyspace) {        if (keyspace != null) {            statement.setKeyspace(CqlIdentifier.fromCql(keyspace));        }         return session.execute(statement);    }     // ...}

Note that we're overloading the method *createTable*.

The idea behind overloading this method is to have two options for the
table creation:

-   Create the table in a specific keyspace, sending keyspace name as
    the parameter, independently of which keyspace is the session
    currently using
-   Start using a keyspace in the session, and use the method for the
    table creation without any parameter — in this case, the table will
    be created in the keyspace the session is currently using

**3.4. Insert Data**

In addition, the driver provides prepared and bounded statements.

**The *PreparedStatement* is typically used for queries executed often,
with changes only in the values.**

We can fill the *PreparedStatement* with the values we need. After that,
we'll create a *BoundStatement* and execute it.

Let's write a method for inserting some data into the database:

    public class VideoRepository {     //...     public UUID insertVideo(Video video, String keyspace) {        UUID videoId = UUID.randomUUID();         video.setId(videoId);         RegularInsert insertInto = QueryBuilder.insertInto(TABLE_NAME)          .value("video_id", QueryBuilder.bindMarker())          .value("title", QueryBuilder.bindMarker())          .value("creation_date", QueryBuilder.bindMarker());         SimpleStatement insertStatement = insertInto.build();         if (keyspace != null) {            insertStatement = insertStatement.setKeyspace(keyspace);        }         PreparedStatement preparedStatement = session.prepare(insertStatement);         BoundStatement statement = preparedStatement.bind()          .setUuid(0, video.getId())          .setString(1, video.getTitle())          .setInstant(2, video.getCreationDate());         session.execute(statement);         return videoId;    }     // ...}

**3.5. Query Data**

Now, let's add a method that creates a simple query to get the data
we've stored in the database:

    public class VideoRepository {     // ...     public List<Video> selectAll(String keyspace) {        Select select = QueryBuilder.selectFrom(TABLE_NAME).all();         ResultSet resultSet = executeStatement(select.build(), keyspace);         List<Video> result = new ArrayList<>();         resultSet.forEach(x -> result.add(            new Video(x.getUuid("video_id"), x.getString("title"), x.getInstant("creation_date"))        ));         return result;    }     // ...}

**3.6. Putting It All Together**

Finally, let's see an example using each section we've covered in this
tutorial:

    public class Application {     public void run() {        CassandraConnector connector = new CassandraConnector();        connector.connect("127.0.0.1", 9042, "datacenter1");        CqlSession session = connector.getSession();         KeyspaceRepository keyspaceRepository = new KeyspaceRepository(session);         keyspaceRepository.createKeyspace("testKeyspace", 1);        keyspaceRepository.useKeyspace("testKeyspace");         VideoRepository videoRepository = new VideoRepository(session);         videoRepository.createTable();         videoRepository.insertVideo(new Video("Video Title 1", Instant.now()));        videoRepository.insertVideo(new Video("Video Title 2",          Instant.now().minus(1, ChronoUnit.DAYS)));         List<Video> videos = videoRepository.selectAll();         videos.forEach(x -> LOG.info(x.toString()));         connector.close();    }}

After we execute our example, as a result, we can see in the logs that
the data was properly stored in the database:

    INFO com.baeldung.datastax.cassandra.Application - [id:733249eb-914c-4153-8698-4f58992c4ad4, title:Video Title 1, creationDate: 2019-07-10T19:43:35.112Z]INFO com.baeldung.datastax.cassandra.Application - [id:a6568236-77d7-42f2-a35a-b4c79afabccf, title:Video Title 2, creationDate: 2019-07-09T19:43:35.181Z]

**​4. Conclusion**

In this tutorial, we covered the basic concepts of the DataStax Java
Driver for Apache Cassandra. We connected to the database and created a
keyspace and table. Also, we inserted data into the table and ran a
query to retrieve it.

As always, the source code for this tutorial is available [over on
Github](https://github.com/fenago/apache-cassandra-intellij/tree/master/java-cassandra).
