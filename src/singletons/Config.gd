extends Node

const SHOW_HEALTH_BARS := true
const PLAYER_INVINCIBLE := true
#var active_camera	= null
#var world			= null


func _ready() -> void:
	OS.center_window()
	Engine.target_fps = 60
	randomize()


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	if Input.is_key_pressed(KEY_ESCAPE) and OS.is_debug_build():
		get_tree().quit()
