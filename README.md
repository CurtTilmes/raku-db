DB - Base roles for DB::* family of SQL Database Access Modules
===============================================================

This module abstracts out some shared functionality from a set of
concrete modules for performing database access.

You can't actually do anything directly with these.  The documentation
here will only be useful if you want to understand the internals of
the DB modules, or implement your own similar `DB::*` module.

DB
--
DB holds a cache of database connections.

`.connect(--> DB::Connection)` - virtual, create a new connection

`.db(--> DB::Connection)` - Returns a cached connection

`.cache(DB::Connection:D $db)` - Returns a connection to the cache


`.query()` - Allocates a connection, calls `.query()`, then returns
the connection.

`.execute()` - Allocates a connection, calls `.execute()`, then
returns the connection.

`.finish()` - For each cached connection, call `.clear-cache()` and
`.DESTROY()`.


Acknowledgements
----------------

Inspiration taken from the existing Perl6
[DBIish](https://github.com/perl6/DBIish) module as well as the Perl 5
[Mojo::Pg](http://mojolicious.org/perldoc/Mojo/Pg) from the
Mojolicious project.
