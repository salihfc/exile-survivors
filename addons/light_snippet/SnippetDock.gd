tool
extends Control

"""
	Handles dock and data operations
"""

const SNIPPET_CLASS_NAME = "Snippet"
const SNIPPET_BUTTON = preload("res://addons/light_snippet/SnippetButton.tscn")
const SNIPPETS_DIR = "res://addons/light_snippet/snippets/"
const SEARCH_DELAY = 0.1


signal snippet_display_request(snip_name, snip_data)


onready var snippetList = $Panel/SnippetList
onready var searchTimer = $Panel/MenuBar/SearchInput/SearchTimer
onready var addButton	= $Panel/MenuBar/AddButton

onready var snippetNameInput	= $SnippetInputDialog/SnippetNameInput
onready var snippetDataInput	= $SnippetInputDialog/SnippetDataInput
onready var snippetInputDialog 	= $SnippetInputDialog

var snippet_path_cache = {}
var snippet_data_cache = {}
var recent_text = ""

func _ready() -> void:
	addButton.icon = get_icon("Add", "EditorIcons")
	pass


func init(snippet_dict) -> void:
	
	for key in snippet_dict.keys():
		var snip_name = key
		var snip_path = snippet_dict[key]
		
		var snippet = load(snip_path)
		
		prints (snippet, snippet.get_class())
		if snippet == null or snippet.get_class() != SNIPPET_CLASS_NAME:
			continue
		
		snippet_data_cache[snip_name] = snippet
		snippet_path_cache[snip_name] = snip_path

		create_snippet_button(snippet)



func create_snippet_button(snippet) -> void:
	# Create snippet button
	var button = SNIPPET_BUTTON.instance()
	button.text = snippet.get_name()
	button.connect("pressed", self, "_on_snip_button_pressed", [snippet.get_name()])
	snippetList.add_child(button)

	var children = snippetList.get_children()
	children.sort_custom(self, "SnippetComparison")
	for child in children:
		child.raise()



func _on_snip_button_pressed(snip_name) -> void:
	# Copy snip text to clipboard 
	var snippet = snippet_data_cache[snip_name]
	var snippet_text = snippet.get_data()
	
	OS.set_clipboard(snippet_text)
	print ("COPY: (%s)" % [snippet.get_name()])



func create_new_snip(snip_name, snip_data) -> void:
	var new_snip = Snippet.new(snip_name, snip_data)
	var path     = SNIPPETS_DIR + snip_name + ".tres"
	ResourceSaver.save(path, new_snip)
	create_snippet_button(new_snip)

	snippet_data_cache[snip_name] = new_snip
	snippet_path_cache[snip_name] = path



func read_file_as_string(filepath) -> String:
	var file = File.new()
	file.open(filepath, File.READ)
	
	var data = file.get_as_text()
	file.close()
	
	return data



func is_valid_snippet_name(snip_name : String) -> bool:
	return snip_name.length() > 0 and snip_name.is_valid_filename()



func is_valid_snippet_data(snip_data : String) -> bool:
	return snip_data.length() > 0




################################################################################
################################################################################
################################################################################

func _on_SearchInput_text_changed(new_text: String) -> void:
	searchTimer.start(SEARCH_DELAY)
	recent_text = new_text
	


func _on_SearchTimer_timeout() -> void:
	for button in snippetList.get_children():
		var is_prefix_of = button.text.begins_with(recent_text)
		button.visible = is_prefix_of



func _on_AddButton_pressed() -> void:
	snippetInputDialog.popup_centered()



func _on_OkButton_pressed() -> void:
	var new_snippet_name = snippetNameInput.get_text()
	var new_snippet_data = snippetDataInput.get_text()
	 
	if not is_valid_snippet_name(new_snippet_name):
		push_error("Snippet name [%s] is not valid!" % [new_snippet_name])

	if not is_valid_snippet_data(new_snippet_data):
		push_error("Snippet data [%s] is not valid!" % [new_snippet_data])

	create_new_snip(new_snippet_name, new_snippet_data)
	
	snippetDataInput.clear_undo_history()
	snippetDataInput.text = ""
	snippetNameInput.clear()
	snippetInputDialog.hide()



func _on_CancelButton_pressed() -> void:
	snippetDataInput.clear_undo_history()
	snippetDataInput.text = ""
	snippetNameInput.clear()
	snippetInputDialog.hide()



################################################################################
################################################################################
################################################################################

func SnippetComparison(a, b):
	if typeof(a) != typeof(b):
		return typeof(a) < typeof(b)
	else:
		return a.text < b.text
