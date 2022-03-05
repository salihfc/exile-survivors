tool
extends TextureRect

const BUSY_COLOR = Color.red
const IDLE_COLOR = Color.green
const FADE_DURATION = 0.7

onready var tween = $Tween

signal status_busy()
signal status_done()


func _ready() -> void:
	modulate = IDLE_COLOR



func set_busy() -> void:
	modulate = BUSY_COLOR
	yield(get_tree().create_timer(0.02), "timeout")
	emit_signal("status_busy")



func set_done() -> void:
	tween.remove_all()
	tween.interpolate_method(self, "set_modulate", 
			modulate, IDLE_COLOR, 
			FADE_DURATION,
			Tween.TRANS_QUART, Tween.EASE_IN_OUT)
	tween.start()

	yield(get_tree().create_timer(0.02), "timeout")
	emit_signal("status_done")

