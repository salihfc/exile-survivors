extends KinematicBody2D
class_name Player
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
export(float) var max_hp := 100.0

### PUBLIC VAR ###

### PRIVATE VAR ###
var _velocity := Vector2.ZERO
var _hp := 1.0

### ONREADY VAR ###
onready var hpBar = $Hp_bar



### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	_set_hp(max_hp)


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
func take_damage(amount : float) -> void:
	_set_hp(_hp - amount)


func alive() -> bool:
	return _hp > 0.0


### PRIVATE FUNCTIONS ###
func _set_hp(new_hp) -> void:
	_hp = new_hp
	hpBar.set_bar(_hp / max_hp)
	if not alive():
		queue_free()

### SIGNAL RESPONSES ###
