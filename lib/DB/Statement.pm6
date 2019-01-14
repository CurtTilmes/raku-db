role DB::Statement
{
    has $.db;

    method clear() {}

    method free() {}

    method execute(|) {...}

    method finish()
    {
        self.clear;
        $!db.finish;
    }

    submethod DESTROY() { .free }
}
