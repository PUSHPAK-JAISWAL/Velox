module core

pub const (
	weight_prefix    = 5.0
	weight_substring = 3.0
	weight_semantic  = 2.5
	weight_usage     = 2.0
)

// final score calculation
pub fn calculate_score(
	query string,
	name string,
	usage_boost f64
) f64 {

	mut score := 0.0

	if name.starts_with(query) {
		score += weight_prefix
	}

	if name.contains(query) {
		score += weight_substring
	}

	score += semantic_score(query, name) * weight_semantic

	score += usage_boost * weight_usage

	return score
}