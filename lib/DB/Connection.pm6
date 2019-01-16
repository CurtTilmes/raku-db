use DB::Statement;

role DB::Connection
{
    has $.owner is required;
    has Bool $!transaction = False;
    has %!prepare-cache;

    method ping(--> Bool) { True }

    method free(--> Nil) {}

    method prepare-nocache(Str:D $query --> DB::Statement) {...}

    # execute defaults to the same as query(), but some modules
    # do different things with it.
    method execute(Str:D $command, Bool :$finish, |args)
    {
        $.prepare($command).execute(|args, :$finish);
    }

    method clear-cache(--> Nil)
    {
        .free for %!prepare-cache.values;
        %!prepare-cache = ()
    }

    method finish(--> Nil)
    {
        if $.ping
        {
            if $!transaction
            {
                self.rollback;
                $!transaction = False;
            }
            $!owner.cache(self);
        }
        else
        {
            self.DESTROY
        }
    }

    method prepare(Str:D $query --> DB::Statement)
    {
        return $_ with %!prepare-cache{$query};
        %!prepare-cache{$query} = $.prepare-nocache($query)
    }

    method query(Str:D $query, Bool :$finish, |args)
    {
        $.prepare($query).execute(|args, :$finish);
    }

    method begin(--> DB::Connection)
    {
        self.execute('begin');
        $!transaction = True;
        self
    }

    method commit(--> DB::Connection)
    {
        self.execute('commit');
        $!transaction = False;
        self
    }

    method rollback(--> DB::Connection)
    {
        self.execute('rollback');
        $!transaction = False;
        self
    }

    submethod DESTROY()
    {
        self.clear-cache;
        self.free
    }
}
