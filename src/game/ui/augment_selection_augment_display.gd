extends Panel
class_name AugmentSelectionAugmentDisplay
"""

"""

### SIGNAL ###
signal display_pressed(augment)

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _augment_weakref

### ONREADY VAR ###
onready var textureRect = $TextureButton/TextureRect as TextureRect
onready var richLabel = $TextureButton/RichTextLabel as RichTextLabel



### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func set_augment(augment : Augment) -> void:
	_augment_weakref = weakref(augment)
# warning-ignore:unsafe_property_access
	textureRect.texture = augment.icon
# warning-ignore:unsafe_property_access
	richLabel.bbcode_text = """
		[center] %s [/center]
	""" % [augment.augment_description]

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_TextureButton_pressed() -> void:
	emit_signal("display_pressed", _augment_weakref.get_ref())
