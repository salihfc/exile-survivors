extends ProgressBar
class_name HpBar

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var tween = $Tween as Tween


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	hide()
	value = 100.0


### PUBLIC FUNCTIONS ###
func set_bar(new_value : float) -> void:
	new_value *= 100.0
	tween.remove_all()
	tween.interpolate_property(self, "value",
			value, new_value, 
			0.3, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)
	tween.start()
	
	if new_value < 100.0:
		show()

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
