extends Node2D

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const BASE_LIFETIME = 0.2
const BASE_SPEED = 1.0

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var particles2d = $Particles2D as Particles2D


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
# warning-ignore:unused_argument
func start(lifetime_scale := 1.0) -> void:
	particles2d.lifetime = BASE_LIFETIME * lifetime_scale
	particles2d.speed_scale = BASE_SPEED * sqrt(lifetime_scale)
	particles2d.emitting = true


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
