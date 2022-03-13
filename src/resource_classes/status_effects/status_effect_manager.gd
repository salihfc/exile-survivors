extends Node
class_name StatusEffectManager
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _effects = []

### ONREADY VAR ###



### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func add_effect(effect : StatusEffect) -> void:
	UTILS.bind(
		effect, "expired",
		self, "_on_effect_expired", [effect]
	)
	_effects.append(effect)




### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###

func _on_effect_expired(effect) -> void:
	_effects.erase(effect)
