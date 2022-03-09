extends Node2D

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###

### PUBLIC VAR ###


### PRIVATE VAR ###
var _damage


### ONREADY VAR ###
onready var sprite = $Sprite as Sprite
onready var particles = $CPUParticles2D as CPUParticles2D
onready var animPlayer = $AnimationPlayer as AnimationPlayer

onready var hitBox = $HitBox as HitBox 
### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func init(damage, delay, global_pos) -> void:
	set_as_toplevel(true)
	global_position = global_pos
	_damage = damage
	
	assert(delay > 0.0)
	animPlayer.playback_speed = 1.0 / delay
	animPlayer.play("buildup")


func set_range(t) -> void:
	scale.x = t
	scale.y = t

	sprite.scale.x = 1
	sprite.scale.y = 1


### PRIVATE FUNCTIONS ###
func _explode() -> void:
	sprite.hide()
	particles.show()
	particles.emitting = true
	_hit()


func _hit() -> void:
	var overlap = hitBox.get_overlapping_areas()
	for area in overlap:
		var unit = area.get_parent()
		unit.take_damage(_damage)

	yield(get_tree().create_timer(0.3), "timeout")
	queue_free()

### SIGNAL RESPONSES ###
