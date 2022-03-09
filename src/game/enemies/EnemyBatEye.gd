extends Enemy
class_name EnemyBatEye
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const FLIP_THRESHOLD = 20.0

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var animSprite = $AnimatedSprite as AnimatedSprite
onready var animTween = $AnimTween as Tween


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	_main_sprite = animSprite


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if abs(_velocity.x) > FLIP_THRESHOLD:
		animSprite.flip_h = _velocity.x < 0.0


### PUBLIC FUNCTIONS ###
# Overriding Enemy.take_damage
func take_damage(amount : float) -> void:
	_set_hp(_hp - amount)
	
	animTween.remove_all()

	var to_red_duration = 0.1
	var to_white_duration = 0.1
	var current_modulate = animSprite.modulate
	
	# Flash to red then back to white
	animTween.interpolate_property(
			animSprite, "modulate",
			current_modulate, Color.red,
			to_red_duration,
			Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)

	animTween.interpolate_property(
			animSprite, "modulate",
			Color.red, current_modulate,
			to_white_duration,
			Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			to_red_duration
	)
	
	animTween.start()
	
	

### PRIVATE FUNCTIONS ###
func _on_freeze_for(time : float) -> void:
	._on_freeze_for(time)
	animSprite.playing = false


func _on_unfreeze(before_freeze_modulate) -> void:
	._on_unfreeze(before_freeze_modulate)
	animSprite.playing = true

### SIGNAL RESPONSES ###
