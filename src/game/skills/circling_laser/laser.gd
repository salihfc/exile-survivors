extends Line2D
class_name Laser
"""

"""

### SIGNAL ###
signal circling_done()

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var tween = $Tween as Tween
onready var hitBox = $HitBox as HitBox


### VIRTUAL FUNCTIONS (_init ...) ###
var _center = Vector2.ZERO

### PUBLIC FUNCTIONS ###
func init(start : Vector2, end : Vector2) -> void:
	clear_points()
	add_point(start)
	add_point(end)


func get_start() -> Vector2:
	return get_point_position(0)


func get_end() -> Vector2:
	return get_point_position(1)


func get_len() -> float:
	return get_start().distance_to(get_end())


func get_radius() -> float:
	return _center.distance_to(get_end())


func update_start(new_start : Vector2) -> void:
	set_point_position(0, new_start)


func update_end(new_end : Vector2) -> void:
	set_point_position(1, new_end)


func update_len(new_len : float) -> void:
	assert(get_point_count() == 2)
	var start = get_start()
	var new_end = start + start.direction_to(get_end()) * new_len
	update_end(new_end)


func circle_around(center : Vector2) -> void:
	_center = center
	# RANDOM START ANGLE
	var start_angle = rand_range(0.0, 2 * PI)
	var end_angle = start_angle + 2 * PI
	var duration = 1.0
	
	tween.interpolate_method(
			self, "_set_end_at_angle",
			start_angle, end_angle,
			duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT
	)
	
	tween.start()


### PRIVATE FUNCTIONS ###
func _set_end_at_angle(rads : float) -> void:
	var new_dir = UTILS.angle_to_vec2(rads)
	var new_end = _center + new_dir * get_radius()
	update_end(new_end)
	hitBox.position = get_end()
#	LOG.pr(1, "RADS: (%s) --> [ %s ,  %s,  %s]" % [rads, get_start(), get_end(), get_radius()])


### SIGNAL RESPONSES ###


func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	emit_signal("circling_done")
	tween.remove(object, key)
