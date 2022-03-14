tool
extends Area2D
class_name SoftBody2D
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const MAX_CHECKS = 10
const BODY_RANGE = 200.0
const MAX_PUSH_FORCE = 800.0

### EXPORT ###
export(NodePath) var parent_path
export(Shape2D) var body_shape setget set_shape


func set_shape(new_shape) -> void:
	body_shape = new_shape
	var collision_shape = ($CollisionShape2D as CollisionShape2D)
#	print("set_shape (%s), %s" % [new_shape, collision_shape])
	collision_shape.set_deferred("shape", new_shape)

### PUBLIC VAR ###


### PRIVATE VAR ###
var _overlapping_bodies = []

### ONREADY VAR ###



### VIRTUAL FUNCTIONS (_init ...) ###
#func _ready() -> void:
	

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
# warning-ignore:unsafe_property_access
	if not Engine.editor_hint:
		var other_bodies = _get_soft_bodies_inside()
		if other_bodies.size() > MAX_CHECKS:
			other_bodies.resize(MAX_CHECKS)

		for body in other_bodies:
			_push_body(body, delta)
	

### PUBLIC FUNCTIONS ###
func apply_force(force : Vector2) -> void:
	var parent = get_node(parent_path)
	if parent:
		parent.apply_force(force)


### PRIVATE FUNCTIONS ###
func _push_body(body, delta) -> void:
	var dist = global_position.distance_to(body.global_position)
	var force_factor = UTILS.clamp01(dist / BODY_RANGE)
#	var force_factor = 0.0 # TEST

	force_factor = 1.2 - 2 * (force_factor * force_factor)
	force_factor = UTILS.clamp01(force_factor)
	var force_magnitude = lerp(0.0, MAX_PUSH_FORCE, force_factor)
	var force_dir = (body.global_position - global_position).normalized()
	var force = force_dir * force_magnitude
	body.apply_force(force * delta)


func _get_soft_bodies_inside() -> Array:
#	if not get_node(parent_path) is Player\
#		and (Engine.get_physics_frames() % TIME_SLICER.SLICE_COUNT != get_node(parent_path).time_id):
#		return []
	return _overlapping_bodies

#	if not get_node(parent_path) is Player\
#		and (Engine.get_physics_frames() % TIME_SLICER.SLICE_COUNT != get_node(parent_path).time_id):
#		return []
#
#	var overlap = get_overlapping_areas()
#	var soft_bodies = []
#	for body in overlap:
#		soft_bodies.append(body)
#	return soft_bodies

### SIGNAL RESPONSES ###


func _on_SoftBody2D_area_entered(area: Area2D) -> void:
	_overlapping_bodies.append(area)


func _on_SoftBody2D_area_exited(area: Area2D) -> void:
	if area and area.is_inside_tree():
		_overlapping_bodies.erase(area)
