extends CanvasLayer

#

#
const full_transparent = Color(0.0, 0.0, 0.0, 0.0)
const FADE_MIN_DELAY = 0.5
const RECOVERY_MIN_DELAY = 0.5

enum {

}

const SCENES = [

]

#
var fade_requested = false
var last_requested_scene = null
var already_loaded = false

#
onready var tween = get_node("Control/Tween") as Tween
onready var foreground = get_node("Control/Foreground") as ColorRect
onready var fadeTimer = get_node("Control/FadeTimer") as Timer
onready var recoveryTimer = get_node("Control/RecoveryTimer") as Timer

func _ready() -> void:
	set_foreground_color(Color("0c0d1d"))


func set_foreground_color(new_color : Color) -> void:
	foreground.color = new_color
	foreground.color.a = 0


func change_scene(scene_id) -> void:
	already_loaded = false
	last_requested_scene = SCENES[(scene_id)]
	fadeTimer.start(0.5)
	fade(1.0, FADE_MIN_DELAY)


func fade(alpha, duration := 0.5) -> void:
#	LOG.pr(1, "fade (%s , %s)" % [alpha, duration])
	if tween:
		tween.remove_all()
		tween.interpolate_property(foreground, "color:a", 
								   foreground.color.a, alpha, duration\
								   ,Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
		tween.start()


func loaded_scene():
	LOG.pr(1, "loaded_scene")
	if last_requested_scene:
		if recoveryTimer.time_left == 0.0:
			fade(0.0, RECOVERY_MIN_DELAY)
		else:
			already_loaded = true


func _on_FadeTimer_timeout() -> void:
	for ch in $CurrentSceneSlot.get_children():
		$CurrentSceneSlot.remove_child(ch)
		ch.queue_free()
	
	# Can change scene now
	var scene = last_requested_scene.instance()
	$CurrentSceneSlot.add_child(scene)
	
	# Now can start recovery request
	recoveryTimer.start(FADE_MIN_DELAY)


func _on_RecoveryTimer_timeout() -> void:
	if already_loaded:
		fade(0.0, RECOVERY_MIN_DELAY)
