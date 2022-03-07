extends Node2D
class_name Projectile
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _velocity := Vector2.ZERO
var _damage := 0.0
var _max_pierce := 0
var _remaining_pierce := 0

### ONREADY VAR ###
onready var animSprite = $Rotation/AnimatedSprite as AnimatedSprite
onready var collision = $Area2D/CollisionShape2D as CollisionShape2D

### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	look_at(global_position + _velocity)


func _physics_process(delta: float) -> void:
	global_position += _velocity * delta
	
	
### PUBLIC FUNCTIONS ###
func init(velocity, damage, max_pierce) -> void:
	_velocity = velocity
	_damage = damage
	_max_pierce = max_pierce


func get_projectile_damage():
	return _damage


func hit_target() -> void:
	if _remaining_pierce < 0:
		collision.set_deferred("disabled", true)
		queue_free()
		return
	_remaining_pierce -= 1


### PRIVATE FUNCTIONS ###
func _destroy() -> void:
	LOG.pr(1, "Projectile Destroyed")
	animSprite.animation = "end"

### SIGNAL RESPONSES ###


func _on_AnimatedSprite_animation_finished() -> void:
	if animSprite.animation == "end":
		queue_free()
	else:
		animSprite.animation = "loop"
