extends KinematicBody2D
class_name Enemy

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const MAX_VEL	  	  = 200.0
const MAX_STEER_FORCE = 1000.0

### EXPORT ###
export(float) var max_hp := 100.0

### PUBLIC VAR ###


### PRIVATE VAR ###
# Physics
var _velocity := Vector2.ZERO
# Battle
var _hp := 1.0
var _target = null

### ONREADY VAR ###
onready var hp_bar = $Hp_bar as HpBar



### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	_hp = max_hp


func _process(delta: float) -> void:
	if _target:
		_seek(_target.global_position, delta)


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(_velocity * delta)
	if collision:
		pass


### PUBLIC FUNCTIONS ###
func set_target(target) -> void:
	_target = target


func take_damage(amount : float) -> void:
	set_hp(_hp - amount)


### PRIVATE FUNCTIONS ###
func set_hp(new_hp) -> void:
	_hp = new_hp
	hp_bar.set_bar(_hp / max_hp)
	if _hp <= 0.0:
		queue_free()


func _seek(pos, delta) -> void:
	var desired_vel = (pos - global_position).normalized() * MAX_VEL
	var force = (desired_vel - _velocity).normalized() * MAX_STEER_FORCE * delta
	_velocity += force
	_velocity = _velocity.normalized() * min(_velocity.length(), MAX_VEL)

### SIGNAL RESPONSES ###
