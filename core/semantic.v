module core

// Split by common delimiters
pub fn tokenize(s string) []string {
	mut tokens := []string{}
	mut current := ''

	for c in s {
		if c.is_alnum() {
			current += c.ascii_str()
		} else {
			if current.len > 0 {
				tokens << current
				current = ''
			}
		}
	}

	if current.len > 0 {
		tokens << current
	}

	return tokens
}

// Compute semantic token overlap score
pub fn semantic_score(query string, candidate string) f64 {
	q_tokens := tokenize(query)
	c_tokens := tokenize(candidate)

	if q_tokens.len == 0 || c_tokens.len == 0 {
		return 0.0
	}

	mut hits := 0

	for qt in q_tokens {
		for ct in c_tokens {
			if ct == qt {
				hits += 2   // exact match strong boost
				break
			}
			if ct.starts_with(qt) {
				hits += 1   // prefix match
				break
			}
		}
	}

	return f64(hits) / f64(q_tokens.len * 2)
}