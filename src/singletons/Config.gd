extends Node

const SHOW_HEALTH_BARS := true
const PLAYER_INVINCIBLE := true
const AUTO_RANDOM_UPDATE := false
# warning-ignore:unused_class_variable
var SHOW_DAMAGE_NUMBERS := false

# COLORS
const FROZEN_ENEMY_MODULATE_COLOR = Color("#003676")

var data := []
func _enter_tree() -> void:
	var err = get_tree().connect("node_added", self, "_on_node_added")
	if err != OK:
		assert(0)


func _on_node_added(node):
	data.append(node)


func free_orphans() -> void:
	yield(get_tree(), "idle_frame")

	var keep := []
	for a_node in data:
		if is_instance_valid(a_node):
			if not a_node.is_inside_tree() and not a_node.is_queued_for_deletion():
				a_node.queue_free()
			else:
				keep.append(a_node)
	data = keep


func _ready() -> void:
	OS.center_window()
	Engine.target_fps = 60
	randomize()


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	if Input.is_key_pressed(KEY_ESCAPE) and OS.is_debug_build():
#		print_stray_nodes()
		yield(free_orphans(), "completed")

		var all_main_nodes = get_node("/root").get_children()
		for node in all_main_nodes:
			node.queue_free()
		get_tree().call_deferred("quit")
