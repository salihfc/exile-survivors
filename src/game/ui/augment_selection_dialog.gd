extends Control
class_name AugmentSelectionDialog
"""

"""

### SIGNAL ###
signal augment_selected(augment)

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###

### ONREADY VAR ###
onready var panel = $Panel


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	for display in panel.get_children():
		display.connect("display_pressed", self, "_on_display_pressed")


### PUBLIC FUNCTIONS ###
func set_augments(possible_augments : Array) -> void:
	var displays = panel.get_children()
	assert(possible_augments.size() == displays.size())
	
	if CONFIG.AUTO_RANDOM_UPDATE:
		_on_display_pressed(UTILS.get_random_subset(possible_augments, 1)[0])
		return
	
	
	for idx in displays.size():
# warning-ignore:unsafe_cast
		var display = displays[idx] as AugmentSelectionAugmentDisplay
# warning-ignore:unsafe_cast
		var augment = possible_augments[idx] as Augment
		display.set_augment(augment)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###

func _on_display_pressed(augmentInPressedDisplay : Augment) -> void:
	emit_signal("augment_selected", augmentInPressedDisplay)
