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

#
export(float) var base_damage := 20.0 
# warning-ignore:unused_class_variable
export(float) var cd := 5.0 
### PUBLIC VAR ###


### PRIVATE VAR ###
var _applied_augments = []

### ONREADY VAR ###
onready var cdTimer = $CdTimer as Timer



### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func start() -> void:
	cdTimer.start(cd)


func apply_augment(augment : Augment) -> void:
	_applied_augments.append(augment)


### PRIVATE FUNCTIONS ###
func _get_damage() -> float:
	var damage = base_damage
	for augment in _applied_augments:
		if augment is MinorAugmentDamage:
			LOG.pr(1, "augment(%s) is MinorAugmentDamage" % [augment])
			damage += augment.damage_increase_amount
	return damage

### SIGNAL RESPONSES ###


func _on_CdTimer_timeout() -> void:
	pass # Replace with function body.
