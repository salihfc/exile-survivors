extends Area2D
class_name HitBox
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###
# warning-ignore:unused_class_variable
export(NodePath) var parent_path

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func disable(disable := true) -> void:
	if get_child_count():
		for shape in get_children():
			shape.disabled = disable

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
