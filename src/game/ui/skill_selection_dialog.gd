extends Control
class_name SkillSelectionDialog
"""

"""

### SIGNAL ###
signal skill_selected(skill)

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
func set_skills(possible_skills : Array) -> void:
	var displays = panel.get_children()
	assert(possible_skills.size() == displays.size())
	
	for idx in displays.size():
# warning-ignore:unsafe_cast
		var display = displays[idx] as SkillSelectionSkillDisplay
# warning-ignore:unsafe_cast
		var skill = possible_skills[idx] as Skill
		display.set_skill(skill)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###

func _on_display_pressed(skillInPressedDisplay : Skill) -> void:
	emit_signal("skill_selected", skillInPressedDisplay)
