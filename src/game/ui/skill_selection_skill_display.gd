extends Panel
class_name SkillSelectionSkillDisplay

"""

"""

### SIGNAL ###
signal display_pressed(skill)

### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var textureRect = $TextureButton/TextureRect as TextureRect
onready var richLabel = $TextureButton/RichTextLabel as RichTextLabel
onready var textureButton = $TextureButton as TextureButton


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func set_skill(skill : Skill) -> void:
# warning-ignore:unsafe_property_access
	textureRect.texture = skill.icon
# warning-ignore:unsafe_property_access
	richLabel.text = skill.skill_description
	
	if textureButton.is_connected("pressed", self, "_on_TextureButton_pressed"):
		textureButton.disconnect("pressed", self, "_on_TextureButton_pressed")
	
	textureButton.connect("pressed", self, "_on_TextureButton_pressed", [weakref(skill)])


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_TextureButton_pressed(_skill_weakref) -> void:
	if _skill_weakref and _skill_weakref.get_ref():
		emit_signal("display_pressed", _skill_weakref.get_ref())
	
