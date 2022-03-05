extends Node


func random_unit_vec2() -> Vector2:
	var theta = rand_range(0, 2 * PI)
	var cs = cos(theta)
	var vec = Vector2(cs, 1.0 - cs * cs)
	return vec
