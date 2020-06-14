
### User management

As of Apache Cassandra 2.2, Cassandra uses a role-based permission
system. CQL can be utilized by a superuser to create and manage roles
within Apache Cassandra. Roles can be general permission designations
assigned to users or they can be users themselves.

### Note

The syntax provided will be for the role security of Apache Cassandra
2.2 and up. The syntax for managing users in prior versions is
different. Thus, these commands will not work. For information on
managing security in earlier versions, please consult the documentation
for the appropriate version.

#### Creating a user and role

This creates a new role called `cassdba` and gives it a password and the ability to log in and
makes it a superuser:

```
CREATE ROLE cassdba WITH PASSWORD='flynnLives' AND LOGIN=true and SUPERUSER=true;
```

We can also create simple roles:

```
CREATE ROLE data_reader;
CREATE ROLE data_test;
```

Creating non-superuser roles looks something like this:

```
CREATE ROLE kyle WITH PASSWORD='bacon' AND LOGIN=true;
CREATE ROLE nate WITH PASSWORD='canada' AND LOGIN=true;
```



#### Altering a user and role

By far, the most common reason for modifying a role is to change the
password. Run following coomand to change the default `cassandra`
password:

```
ALTER ROLE cassandra WITH PASSWORD=dsfawesomethingdfhdfshdlongandindecipherabledfhdfh';
```

 

#### Dropping a user and role

Removing a user or role is done like this:

```
DROP ROLE data_test;
```

#### Granting permissions

Once created, permissions can be granted to roles:

```
GRANT SELECT ON KEYSPACE fenago_test TO data_reader;
GRANT MODIFY ON KEYSPACE fenago_test TO data_reader;
```

Roles can also be granted to other roles:

```
GRANT data_reader TO kyle;
```

More liberal permissions can also be granted:

```
GRANT ALL PERMISSIONS ON KEYSPACE fenago_test TO kyle;
```

#### Revoking permissions

Sometimes a permission granted to a role will need to be removed. This
can be done with the `REVOKE` command:

```
REVOKE MODIFY ON KEYSPACE fenago_test FROM data_reader;
```
