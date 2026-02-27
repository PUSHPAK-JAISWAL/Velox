module core

import sync

pub struct Entry {
    file_ref u64
    parent_ref u64
    offset u32
    length u16
}

pub struct MemoryIndex {
mut:
    names []u8
    entries []Entry
    prefix_map map[string][]int
    lock sync.RWMutex
}

pub fn new_index() MemoryIndex {
    return MemoryIndex{
        names: []u8{}
        entries: []Entry{}
        prefix_map: map[string][]int{}
    }
}

pub fn (mut m MemoryIndex) add(file_ref u64, parent_ref u64, name string) {
    lower := name.to_lower()

    offset := u32(m.names.len)
    m.names << lower.bytes()

    idx := m.entries.len

    m.entries << Entry{
        file_ref: file_ref
        parent_ref: parent_ref
        offset: offset
        length: u16(lower.len)
    }

    if lower.len >= 2 {
        prefix := lower[..2]
        m.prefix_map[prefix] << idx
    }
}

pub fn (m &MemoryIndex) get_name(i int) string {
    e := m.entries[i]
    return m.names[e.offset..e.offset+u32(e.length)].bytestr()
}