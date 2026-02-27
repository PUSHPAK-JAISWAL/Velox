module core

pub struct Engine {
pub mut:
    db DB
    index MemoryIndex
}

pub fn new_engine(db_path string) !Engine {
    mut db := init_db(db_path)!
    mut idx := new_index()

    stmt := db.conn.prepare('SELECT file_ref,parent_ref,name FROM files;')!
    for {
        if stmt.step() != sqlite.row {
            break
        }
        file_ref := stmt.column_int64(0)
        parent_ref := stmt.column_int64(1)
        name := stmt.column_text(2)
        idx.add(u64(file_ref), u64(parent_ref), name)
    }

    return Engine{
        db: db
        index: idx
    }
}

pub fn (e &Engine) search(q string) []Result {
    return e.index.search(q, 20)
}