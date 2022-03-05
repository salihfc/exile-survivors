tool
extends Control

onready var panel		= $Panel
onready var lineEdit	= $Panel/LineEdit
onready var popupMenu	= $Panel/PopupMenu

const WORD_HEIGHT	:= 60
var MAX_SUGGESTIONS := 5

var word_list := [
	"asdasd",
	"asdasdeq",
	"asdasdww",
	"asdasdqq",
	"asdasdwe",
]

var last_word = ""
signal word_selected(word)
signal aborted()



func clear() -> void:
	lineEdit.clear()



func init(resource_list : Array) -> void:
	word_list.clear()
	for res in resource_list:
		word_list.append(str(res))



func focus_on_line_edit() -> void:
	lineEdit.grab_focus()



func list_items(items : Array) -> void:
	popupMenu.clear()
	
	for item in items:
		popupMenu.add_item(item)
		
	if items.size():
		popupMenu.get_item_index(0)
		popupMenu.popup()

	# Resize panel
	popupMenu.rect_size.y = WORD_HEIGHT * items.size()
	popupMenu.rect_global_position = panel.rect_global_position + Vector2(0, WORD_HEIGHT)
	
	panel.rect_size.y = lineEdit.rect_size.y + popupMenu.rect_size.y * int(popupMenu.visible)




func _on_LineEdit_text_changed(new_text: String) -> void:
	print ("CHANGE: (%s)" % [new_text])
	suggest_from(new_text)



func suggest_from(new_text) -> void:
	last_word = new_text
	var suggest = []
	for word in word_list:
		word = str(word)
		if word.begins_with(new_text):
			suggest.append(word)
	
	if MAX_SUGGESTIONS > 0 and suggest.size() > MAX_SUGGESTIONS:
		suggest = suggest.slice(0, MAX_SUGGESTIONS - 1)

	list_items(suggest)
	lineEdit.grab_focus()



func _on_PopupMenu_index_pressed(index: int) -> void:
	var word = popupMenu.get_item_text(index)
	lineEdit.text = word
	lineEdit.caret_position = word.length()
	emit_signal("word_selected", word)
	panel.rect_size.y = lineEdit.rect_size.y + popupMenu.rect_size.y



func _on_LineEdit_text_entered(new_text: String) -> void:

	for word in word_list:
		if new_text == str(word):
			emit_signal("word_selected", word)
			print ("ENTER: (%s)" % [new_text])



func _on_PopupMenu_focus_entered() -> void:
	var new_event = InputEventAction.new()
	new_event.action	= "ui_down"
	new_event.pressed	= true
	new_event.strength	= 1
	get_tree().input_event(new_event)



func _on_LineEdit_gui_input(event: InputEvent) -> void:
	
	if event is InputEventKey\
			and event.scancode == KEY_ESCAPE\
			and event.is_pressed():

		emit_signal("aborted")
	


func _on_LineEdit_focus_entered() -> void:
	if last_word != lineEdit.text or not popupMenu.visible:
		suggest_from(lineEdit.text)



func _on_QuickResourceSelection_hide() -> void:
	popupMenu.hide()
