module core

import sqlite

pub struct DB {
pub mut:
    conn sqlite.DB
}

pub fn init_db(path string) !DB {
    mut db := sqlite.connect(path)!

    db.exec('PRAGMA journal_mode=WAL;')!
    db.exec('PRAGMA synchronous=NORMAL;')!
    db.exec('PRAGMA temp_store=MEMORY;')!
    db.exec('PRAGMA cache_size=-200000;')!

    db.exec(schema_sql)!

    return DB{
        conn: db
    }
}