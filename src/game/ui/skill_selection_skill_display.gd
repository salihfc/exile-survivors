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
var _skill_weakref 

### ONREADY VAR ###
onready var textureRect = $TextureButton/TextureRect as TextureRect
onready var richLabel = $TextureButton/RichTextLabel as RichTextLabel



### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func set_skill(skill : Skill) -> void:
	_skill_weakref = weakref(_skill_weakref)
# warning-ignore:unsafe_property_access
	textureRect.texture = skill.icon
# warning-ignore:unsafe_property_access
	richLabel.text = skill.skill_description


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_TextureButton_pressed() -> void:
	emit_signal("display_pressed", _skill_weakref.get_ref())
