tool
extends Area2D
class_name SoftBody2D
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const BODY_RANGE = 100.0
const MAX_PUSH_FORCE = 20.0

### EXPORT ###
export(NodePath) var parent_path
export(Shape2D) var body_shape setget set_shape


func set_shape(new_shape) -> void:
	body_shape = new_shape
	var collision_shape = ($CollisionShape2D as CollisionShape2D)
#	print("set_shape (%s), %s" % [new_shape, collision_shape])
	collision_shape.shape = new_shape

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###



### VIRTUAL FUNCTIONS (_init ...) ###
#func _ready() -> void:
	

# warning-ignore:unused_argument
func _physics_process(delta: float) -> void:
	var other_bodies = _get_soft_bodies_inside()
	for body in other_bodies:
		_push_body(body)
	

### PUBLIC FUNCTIONS ###
func apply_force(force : Vector2) -> void:
	var parent = get_node(parent_path)
	if parent:
		parent.apply_force(force)


### PRIVATE FUNCTIONS ###
func _push_body(body) -> void:
	var dist = global_position.distance_to(body.global_position)
	var force_factor = UTILS.clamp01(dist / BODY_RANGE)
	force_factor = 1.2 - 2 * (force_factor * force_factor)
	force_factor = UTILS.clamp01(force_factor)
	var force_magnitude = lerp(0.0, MAX_PUSH_FORCE, force_factor)
	var force_dir = (body.global_position - global_position).normalized()
	var force = force_dir * force_magnitude
	body.apply_force(force)


func _get_soft_bodies_inside() -> Array:
	var overlap = get_overlapping_areas()
	var soft_bodies = []
	for body in overlap:
		soft_bodies.append(body)
	return soft_bodies

### SIGNAL RESPONSES ###
