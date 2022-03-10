extends Enemy

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var animSprite = $AnimatedSprite as AnimatedSprite



### VIRTUAL FUNCTIONS (_init ...) ###
# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if abs(_velocity.x) > FLIP_THRESHOLD:
		animSprite.flip_h = _velocity.x < 0.0

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
