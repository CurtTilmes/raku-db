role DB::Statement
{
    has $.db handles <finish>;

    method execute(|) {...}
}
