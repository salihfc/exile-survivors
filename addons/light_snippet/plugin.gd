tool
extends EditorPlugin

const SnippetDock = preload("res://addons/light_snippet/SnippetDock.tscn")
const SNIPPET_EXT = ".tres"

var dock


func _enter_tree() -> void:
	if dock == null:
		dock = SnippetDock.instance()

	add_control_to_dock(DOCK_SLOT_LEFT_BR, dock)
#	get_editor_interface().get_editor_viewport().add_child(dock)
		# Hide the main panel. Very much required.
	make_visible(false)

	init_dock()



func init_dock() -> void:
	var root = get_editor_interface().get_resource_filesystem().get_filesystem()
	var snippet_dict = _scan(root, SNIPPET_EXT)

	print ("(%s) Files found with ext (%s):" % [snippet_dict.size(), SNIPPET_EXT])
	for file in snippet_dict:
		print (file)
	
	dock.init(snippet_dict)



func _scan(dir : EditorFileSystemDirectory, ext := SNIPPET_EXT):
	print ("IN DIR: (%s)" % [dir.get_name()])
	
	var files = {}
	
	var f = File.new()
	for i in range(dir.get_subdir_count()):
		var subdir = dir.get_subdir(i)
		var subdir_result = _scan(subdir, ext)
		for key in subdir_result.keys():
			files[key] = subdir_result[key]

	for i in range(dir.get_file_count()):
		var file_name = dir.get_file(i)
		if file_name.ends_with(ext):
#			 and load(dir.get_file_path(i)).get_script():
			files[file_name.trim_suffix(ext)] = (dir.get_file_path(i))

	return files



func has_main_screen():
	return false



func make_visible(visible):
	if dock:
		dock.visible = visible



func get_plugin_name():
	return "Light Snippet"



func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("CanvasItem", "EditorIcons")



func _exit_tree():
	if dock:
#		remove_control_from_docks(dock)
		dock.free()
