module core

pub struct Result {
	pub:
		file_ref u64
		score    f64
}

pub fn (m &MemoryIndex) search(query string, limit int, usage_map map[u64]f64) []Result {
	q := query.to_lower()
	if q.len == 0 {
		return []Result{}
	}

	mut results := []Result{}
	mut candidates := []int{}

	// prefix narrowing
	if q.len >= 2 && q[..2] in m.prefix_map {
		candidates = m.prefix_map[q[..2]]
	} else {
		for i in 0 .. m.entries.len {
			candidates << i
		}
	}

	for idx in candidates {
		name := m.get_name(idx)

		usage_boost := if m.entries[idx].file_ref in usage_map {
			usage_map[m.entries[idx].file_ref]
		} else {
			0.0
		}

		score := calculate_score(q, name, usage_boost)

		if score > 0 {
			results << Result{
				file_ref: m.entries[idx].file_ref
				score: score
			}
		}
	}

	// sort by score descending
	results.sort_with_compare(fn (a &Result, b &Result) int {
		if a.score > b.score { return -1 }
		if a.score < b.score { return 1 }
		return 0
	})

	return results[..if results.len > limit { limit } else { results.len }]
}