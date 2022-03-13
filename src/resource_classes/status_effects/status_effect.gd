extends Resource
class_name StatusEffect
"""

"""

### SIGNAL ###
signal expired()

### ENUM ###


### CONST ###


### EXPORT ###
export(float) var duration

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func _init(p_duration : float) -> void:
	duration = p_duration

	TIMER_ALLOC.alloc(self, "_on_duration_passed", duration)


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###

func _on_duration_passed(timer) -> void:
	TIMER_ALLOC.retire(timer)

	emit_signal("expired") # Deletion handled at manager
