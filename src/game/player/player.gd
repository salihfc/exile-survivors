extends Node2D
class_name Player
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const IDLE_THRESHOLD = 10.0
const MAX_VEL = 400.0
const RUN_ANIM_SPEED_APPROX = 300.0
const ACC = 200.0
const DAMP = 0.80

### EXPORT ###
# warning-ignore:unused_class_variable
export(Resource) var stats


### PUBLIC VAR ###


### PRIVATE VAR ###
var _velocity := Vector2.ZERO


### ONREADY VAR ###
onready var hpBar = $Hp_bar as HpBar
onready var anim_sprite = $AnimatedSprite as AnimatedSprite
onready var camera = $Camera2D as Camera2D
onready var skillContainer = $Skills as Node2D

### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	_set_hp(stats.get_stat(Stats.MAX_HP))
	camera.current = true
	anim_sprite.speed_scale = MAX_VEL / RUN_ANIM_SPEED_APPROX
	
	for skill in skillContainer.get_children():
		skill.user = self
		skill.start()
	


# warning-ignore:unused_argument
func _process(delta: float) -> void:

	if Engine.time_scale > 0.0: # Active
		var dir := Vector2(
				- Input.get_action_strength("ui_left") + Input.get_action_strength("ui_right"),
				- Input.get_action_strength("ui_up") + Input.get_action_strength("ui_down")
		)
		_velocity += dir.normalized() * ACC
		_velocity = _velocity.normalized() * min(_velocity.length(), MAX_VEL)
		
		# Anim Update
		anim_sprite.scale.x = -1.0 if (_velocity.x < 0.0) else 1.0
		
		#
		anim_sprite.animation = "idle" if _velocity.length() < IDLE_THRESHOLD else "run"
		anim_sprite.material.set_shader_param("velocity", _velocity)
		
#		LOG.pr(1, "(%s)" % [camera.global_position])


func _physics_process(delta: float) -> void:
	_velocity = (_velocity) * DAMP
	global_position += _velocity * delta


### PUBLIC FUNCTIONS ###
func apply_force(force : Vector2) -> void:
	_velocity += force


func take_damage(amount : float) -> void:
	if not CONFIG.PLAYER_INVINCIBLE:
		_set_hp(stats.get_stat(Stats.HP) - amount)


func alive() -> bool:
	return stats.get_stat(Stats.HP) > 0.0


func get_skills() -> Array:
	return skillContainer.get_children()


func get_chance_to_freeze() -> float:
	return 0.1


### PRIVATE FUNCTIONS ###
func _set_hp(new_hp) -> void:
	stats.set_stat(Stats.HP, new_hp)
	hpBar.set_bar(stats.get_hp_perc())
	if not alive():
#		queue_free()
		get_tree().quit()

### SIGNAL RESPONSES ###
