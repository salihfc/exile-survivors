extends Skill

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const MinePrefab = preload("res://src/game/skills/mine/mine.tscn")

### EXPORT ###
export(float) var mine_explosion_delay

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var mineContainer = $MineContainer as Node2D


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func place_mine() -> void:
	var mine = MinePrefab.instance()
	mineContainer.add_child(mine)
	mine.init(base_damage, mine_explosion_delay, global_position)


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_CdTimer_timeout() -> void:
	place_mine()
	cdTimer.start(cd)
