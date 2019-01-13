class DB::Result::ArrayIterator does Iterator
{
    has $.result;
    has Bool $.finish;

    method pull-one()
    {
        $!result.row or do
        {
            $!result.finish if $!finish;
            IterationEnd
        }
    }
}

class DB::Result::HashIterator does Iterator
{
    has $.result;
    has Bool $.finish;

    method pull-one()
    {
        my $row = $!result.row or do
        {
            $!result.finish if $!finish;
            return IterationEnd
        }
        %( $!result.keys.list Z=> @$row )
    }
}

role DB::Result
{
    has $.sth;
    has Bool $.finish = False;

    method free() {}

    method finish() { $.free; .finish with $!sth }

    method row() { ... }

    method names() { ... }

    method keys()
    {
        state $keys;
        $keys // ($keys = $.names)
    }

    method value()
    {
        LEAVE $.finish if $!finish;
        $.row[0]
    }

    method array()
    {
        LEAVE $.finish if $!finish;
        $.row
    }

    method hash()
    {
        LEAVE $.finish if $!finish;
        %( @$.keys Z=> @$.row )
    }

    method arrays()
    {
        Seq.new: DB::Result::ArrayIterator.new(result => self, :$!finish)
    }

    method hashes()
    {
        Seq.new: DB::Result::HashIterator.new(result => self, :$!finish)
    }
}
