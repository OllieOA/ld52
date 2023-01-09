class_name ScoreTracker extends Resource

export var best_run_score := 0
export var best_visited_score := 0

func update_best_scores(curr_score: int, curr_visited: int) -> void:
	if curr_score > best_run_score:
		best_run_score = curr_score
	
	if curr_visited > best_visited_score:
		best_visited_score = curr_visited