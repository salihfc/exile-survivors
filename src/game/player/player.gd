extends Node2D
class_name Player
"""

"""

### SIGNAL ###
signal object_created(obj)

### ENUM ###


### CONST ###
const ProjectilePrefab = preload("res://src/game/projectile.tscn")

const IDLE_THRESHOLD = 10.0
const MAX_VEL = 600.0
const RUN_ANIM_SPEED_APPROX = 300.0
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
onready var anim_sprite = $AnimatedSprite


### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	_set_hp(max_hp)
	anim_sprite.speed_scale = MAX_VEL / RUN_ANIM_SPEED_APPROX


# warning-ignore:unused_argument
func _process(delta: float) -> void:

	if not Engine.editor_hint:
		var dir := Vector2(
				- Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right"),
				- Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
		)
		_velocity += dir.normalized() * ACC
		_velocity = _velocity.normalized() * min(_velocity.length(), MAX_VEL)
		
		# Anim Update
		anim_sprite.flip_h = _velocity.x < 0.0
		anim_sprite.animation = "idle" if _velocity.length() < IDLE_THRESHOLD else "run"

		if Input.is_action_just_pressed("shoot"):
			var projectile = ProjectilePrefab.instance()
			projectile.set_dir((get_global_mouse_position() - global_position).normalized())
			projectile.global_position = global_position
			emit_signal("object_created", projectile)


func _physics_process(delta: float) -> void:
	_velocity = (_velocity) * DAMP
	global_position += _velocity * delta


### PUBLIC FUNCTIONS ###
func apply_force(force : Vector2) -> void:
	_velocity += force


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
		get_tree().quit()

### SIGNAL RESPONSES ###
