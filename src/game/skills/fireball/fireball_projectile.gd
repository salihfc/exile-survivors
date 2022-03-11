extends Node2D
class_name Projectile
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const FADE_DURATION = 0.4
const FORCE_FACTOR = 0.1

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _velocity := Vector2.ZERO
var _damage := 0.0
var _max_pierce := 0
var _remaining_pierce := 0
var _force := 0.0

### ONREADY VAR ###
onready var animSprite = $Rotation/AnimatedSprite as AnimatedSprite
onready var collision = $HitBox/CollisionShape2D as CollisionShape2D
onready var tween = $Tween as Tween

### VIRTUAL FUNCTIONS (_init ...) ###

func _ready() -> void:
	look_at(global_position + _velocity)


func _physics_process(delta: float) -> void:
	global_position += _velocity * delta
	
	
### PUBLIC FUNCTIONS ###
func init(velocity, damage, max_pierce, force) -> void:
	LOG.pr(1, "New Fireball proj (%s) (%s, %s)" % [velocity, damage, max_pierce])
	_velocity = velocity
	_damage = damage
	_max_pierce = max_pierce
	_remaining_pierce = max_pierce
	_force = force


func get_projectile_damage():
	return _damage


func get_push_force():
	return _velocity * _force * FORCE_FACTOR


func hit_target() -> void:
	if _remaining_pierce <= 0:
		collision.set_deferred("disabled", true)
		_destroy()
		return
	_remaining_pierce -= 1


### PRIVATE FUNCTIONS ###
func _destroy() -> void:
	LOG.pr(1, "Projectile Destroyed")
	animSprite.animation = "end"
	_velocity *= 0.1
	
	tween.interpolate_property(
			self, "modulate",
			modulate, Color.transparent,
			FADE_DURATION,
			Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)
	
	tween.interpolate_callback(self, FADE_DURATION, "queue_free")

	tween.start()

### SIGNAL RESPONSES ###
