extends Enemy
class_name EnemyBatEye
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var anim_sprite = $AnimatedSprite as AnimatedSprite



### VIRTUAL FUNCTIONS (_init ...) ###
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	anim_sprite.flip_h = _velocity.x < 0.0

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
