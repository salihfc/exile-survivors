extends KinematicBody2D

"""

"""

### SIGNAL ###
signal object_created(obj)

### ENUM ###


### CONST ###
const ProjectilePrefab = preload("res://src/game/projectile.tscn")

const MAX_VEL = 800.0
const ACC = 200.0
const DAMP = 0.80

### EXPORT ###
# warning-ignore:unused_class_variable
export(int, LAYERS_2D_PHYSICS) var hurt_box_layer = 0

### PUBLIC VAR ###


### PRIVATE VAR ###
var _velocity := Vector2.ZERO


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	pass


# warning-ignore:unused_argument
func _process(delta: float) -> void:

	var dir := Vector2(
			- Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right"),
			- Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
	)
	_velocity += dir.normalized() * ACC
	_velocity = _velocity.normalized() * min(_velocity.length(), MAX_VEL)

	if Input.is_action_just_pressed("shoot"):
		var projectile = ProjectilePrefab.instance()
		projectile.set_dir((get_global_mouse_position() - global_position).normalized())
		projectile.global_position = global_position
		emit_signal("object_created", projectile)



func _physics_process(delta: float) -> void:
	_velocity = (_velocity) * DAMP
	var collision = move_and_collide(_velocity * delta)
	if collision:
		_velocity = Vector2.ZERO

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
