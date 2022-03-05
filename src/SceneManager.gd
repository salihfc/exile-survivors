extends CanvasLayer

#

#
const full_transparent = Color(0.0, 0.0, 0.0, 0.0)
const FADE_MIN_DELAY = 0.5
const RECOVERY_MIN_DELAY = 0.5

enum {
	BATTLE
}

const SCENES = {
	BATTLE : preload("res://src/game/battle/battle.tscn")
}

#
onready var tween = get_node("Control/Tween") as Tween
onready var foreground = get_node("Control/Foreground") as ColorRect


func _ready() -> void:
	set_foreground_color(Color("0c0d1d"))
	change_scene(BATTLE)


func set_foreground_color(new_color : Color) -> void:
	foreground.color = new_color
	foreground.color.a = 0



func change_scene(scene_id) -> void:
	fade(1.0, FADE_MIN_DELAY)
	var scene = SCENES[(scene_id)].instance()
	$CurrentSceneSlot.add_child(scene)
	
	# Should wait until scene fully loaded
	yield(get_tree().create_timer(1.0), "timeout")
	fade(0.0, RECOVERY_MIN_DELAY)
	


func fade(alpha, duration := 0.5) -> void:
#	LOG.pr(1, "fade (%s , %s)" % [alpha, duration])
	if tween:
		tween.remove_all()
		tween.interpolate_property(foreground, "color:a", 
								   foreground.color.a, alpha, duration\
								   ,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()
