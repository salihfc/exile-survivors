tool
extends Control

signal input_entered(text)
signal aborted()
onready var lineEdit = $Panel/LineEdit


func clear() -> void:
	lineEdit.clear()



func focus_on_line_edit() -> void:
	lineEdit.grab_focus()



func _on_LineEdit_gui_input(event: InputEvent) -> void:
	
	if event is InputEventKey\
			and event.scancode == KEY_ESCAPE\
			and event.is_pressed():
		
#		emit_signal("aborted")
		lineEdit.text = ""
		hide()



func _on_LineEdit_focus_exited() -> void:
	lineEdit.text = ""
	hide()
