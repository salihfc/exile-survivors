tool
extends Control
class_name Cell


# SIGNALS
signal cell_selected()
signal cell_value_changed()


# VARS
var col_name : String
var value


# REFS
onready var panel	= $Panel				as Panel
onready var label	= $Panel/Label			as Label
onready var button	= $Panel/Label/Button	as Button



func set_value(_value) -> void:
	value = _value
	label.text = str(value)
	emit_signal("cell_value_changed")



func set_col_name(_col_name) -> void:
	col_name = _col_name



func is_valid_value(value) -> bool:
	return false



func get_value():
	return value



func set_background_color(color) -> void:
	panel.self_modulate = color



func make_immutable(is_immutable = true) -> void:
	button.disabled = is_immutable



func _on_Button_pressed() -> void:
	LOG.pr(0, "CELL SELECTED (%s, %s)" % [col_name, value])
	emit_signal("cell_selected")
