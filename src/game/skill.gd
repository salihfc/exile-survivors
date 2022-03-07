extends Node2D
class_name Skill

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
# warning-ignore:unused_class_variable
export(Texture) var icon
# warning-ignore:unused_class_variable
export(String) var skill_description
# warning-ignore:unused_class_variable
export(Array, Resource) var possible_minor_augments = []

### PUBLIC VAR ###


### PRIVATE VAR ###
var _applied_augments = []

### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func apply_augment(augment : Augment) -> void:
	_applied_augments.append(augment)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
