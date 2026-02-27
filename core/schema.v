module core

pub const schema_sql = '
CREATE TABLE IF NOT EXISTS files (
    file_ref INTEGER PRIMARY KEY,
    parent_ref INTEGER,
    name TEXT NOT NULL,
    lower_name TEXT NOT NULL,
    full_path TEXT NOT NULL,
    last_usn INTEGER DEFAULT 0
);

CREATE TABLE IF NOT EXISTS usage_stats (
    file_ref INTEGER PRIMARY KEY,
    open_count INTEGER DEFAULT 0,
    last_opened INTEGER DEFAULT 0
);

CREATE INDEX IF NOT EXISTS idx_lower_name ON files(lower_name);
CREATE INDEX IF NOT EXISTS idx_last_usn ON files(last_usn);
'