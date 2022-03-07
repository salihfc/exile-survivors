extends Control
class_name ExpDisplay

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var progressBar = $ExpBar as ProgressBar
onready var levelLabel = $LevelLabel as Label


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	progressBar.value = 0
	levelLabel.text = "0"


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
func _on_exp_changed(new_exp, max_exp) -> void:
#	LOG.pr(1, "(%s) / (%s)" % [new_exp, max_exp])
	progressBar.value = new_exp / max_exp * 100.0


func _on_level_up(new_level) -> void:
	levelLabel.text = str(new_level)
