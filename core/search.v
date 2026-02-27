module core

pub struct Result {
    pub:
        file_ref u64
        score f64
}

pub fn (m &MemoryIndex) search(query string, limit int) []Result {
    q := query.to_lower()
    mut results := []Result{}

    if q.len == 0 {
        return results
    }

    mut candidates := []int{}

    if q.len >= 2 && q[..2] in m.prefix_map {
        candidates = m.prefix_map[q[..2]]
    } else {
        for i in 0 .. m.entries.len {
            candidates << i
        }
    }

    for idx in candidates {
        name := m.get_name(idx)

        if name.contains(q) {
            results << Result{
                file_ref: m.entries[idx].file_ref
                score: 1.0
            }
        }
    }

    return results[..if results.len > limit { limit } else { results.len }]
}