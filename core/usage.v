module core

pub fn (mut db DB) increment_usage(file_ref u64) {
    db.conn.exec('
        INSERT INTO usage_stats(file_ref,open_count,last_opened)
        VALUES ($file_ref,1,strftime(\'%s\',\'now\'))
        ON CONFLICT(file_ref)
        DO UPDATE SET
        open_count = open_count + 1,
        last_opened = strftime(\'%s\',\'now\');
    ') or {}
}