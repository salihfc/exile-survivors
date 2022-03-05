extends Node

var active_camera	= null
var world			= null


func _ready() -> void:
	OS.center_window()
	Engine.target_fps = 60


func _process(delta: float) -> void:
	
	if Input.is_key_pressed(KEY_ESCAPE) and OS.is_debug_build():
		get_tree().quit()
