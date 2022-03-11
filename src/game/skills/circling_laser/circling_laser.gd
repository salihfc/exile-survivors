extends Skill
class_name CirclingLaser
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var laser = $Pivot/Laser as Laser
onready var hitBox = $Pivot/Laser/HitBox as HitBox


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	hitBox.disable(false)
	laser.init(Vector2.ZERO, Vector2.ONE * 100.0)
	UTILS.bind(
			laser, "circling_done",
			self, "_on_circling_done"
	)

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###

func _on_circling_done() -> void:
	laser.visible = false
	hitBox.disable()



func _on_CdTimer_timeout() -> void:
	var new_pos = Vector2.DOWN * 100.0
	hitBox.disable(false)
	laser.visible = true
#	yield(get_tree().create_timer(0.1), "timeout")
	laser.circle_around(new_pos)
	cdTimer.start(cd)


func _on_HitBox_area_entered(area: Area2D) -> void:
# warning-ignore:unsafe_property_access
# warning-ignore:unsafe_property_access
	var unit = area.get_node(area.parent_path)
	unit.take_damage(_get_damage())
