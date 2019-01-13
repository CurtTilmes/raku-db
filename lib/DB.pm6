use Concurrent::Stack;
use DB::Database;

role DB
{
    has $.max-connections = 5;
    has $.connections = Concurrent::Stack.new;

    method connect(--> DB::Database) {...}

    method db(--> DB::Database)
    {
        while my $db = $!connections.pop
        {
            return $db if $db.ping;
            $db.DESTROY
        }
        $.connect
    }

    method query(|args)
    {
        $.db.query(:finish, |args)
    }

    method execute(|args)
    {
        $.db.execute(:finish, |args)
    }

    method cache(DB::Database:D $db)
    {
        if $!connections.elems < $!max-connections
        {
            $!connections.push($db)
        }
        else
        {
            $db.DESTROY
        }
    }

    method finish()
    {
        while $_ = $!connections.pop
        {
            .clear-cache;
            .DESTROY;
        }
    }
}
