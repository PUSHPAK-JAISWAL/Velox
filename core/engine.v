pub struct Engine {
pub mut:
	db DB
	index MemoryIndex
	usage_map map[u64]f64
}

pub fn new_engine(db_path string) !Engine {
	mut db := init_db(db_path)!
	mut idx := new_index()
	mut usage := map[u64]f64{}

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

	// load usage stats
	stmt2 := db.conn.prepare('SELECT file_ref,open_count FROM usage_stats;')!
	for {
		if stmt2.step() != sqlite.row {
			break
		}
		file_ref := stmt2.column_int64(0)
		count := stmt2.column_int(1)
		usage[u64(file_ref)] = f64(count)
	}

	return Engine{
		db: db
		index: idx
		usage_map: usage
	}
}

pub fn (e &Engine) search(q string) []Result {
	return e.index.search(q, 20, e.usage_map)
}