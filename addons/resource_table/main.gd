tool
extends EditorPlugin


# A class member to hold the dock during the plugin life cycle.
var dock
var tres_files

#
func _enter_tree():
	
#	remove_autoload_singleton("LOG")
#	remove_autoload_singleton("TYPE")

	add_autoload_singleton("LOG" , "res://addons/resource_table/LOG.gd")
	add_autoload_singleton("TYPE", "res://addons/resource_table/ResourceTableGlobal.gd")
	# Initialization of the plugin goes here.
	# Load the dock scene and instance it.
	# Add the main panel to the editor's main viewport.
	if dock == null:
		dock = preload("res://addons/resource_table/TableDock.tscn").instance()
	
	get_editor_interface().get_editor_viewport().add_child(dock)
		# Hide the main panel. Very much required.
	make_visible(false)

	init_dock()




func init_dock() -> void:
	scan_for_tres_files()
	
	dock.init(tres_files)
	if not dock.is_connected("reload_requested", self, "_on_reload_requested"):
		dock.connect("reload_requested", self, "_on_reload_requested")

	if not dock.is_connected("inspect_requested", self, "_on_inspect_requested"):
		dock.connect("inspect_requested", self, "_on_inspect_requested")



func scan_for_tres_files() -> void:
	tres_files = []
	var root = get_editor_interface().get_resource_filesystem().get_filesystem()
	_scan(root)

	print ("Resource Files found (%s):" % [tres_files.size()])
	for file in tres_files:
		print (file)
#		var res = load(file)
#		types[res.get_class()] = res
#		var res = load(file)
#		add_custom_type(res.get_class(), res.get_base(), res.script, load("res://icon.png"))



func _scan(dir : EditorFileSystemDirectory):
	var f = File.new()
	for i in range(dir.get_subdir_count()):
		_scan(dir.get_subdir(i))
	for i in range(dir.get_file_count()):
		var file_name = dir.get_file(i)
		if file_name.ends_with(".tres") and load(dir.get_file_path(i)).get_script():
			tres_files.append(dir.get_file_path(i))


#func _process(delta: float) -> void:
#	print (get_editor_interface().get_base_control().get_global_mouse_position())


func _on_reload_requested() -> void:
	init_dock()
	dock.on_reload_done()



func _on_inspect_requested(object) -> void:
	var interface = get_editor_interface()
	interface.inspect_object(object)



func has_main_screen():
	return true



func make_visible(visible):
	if dock:
		dock.visible = visible



func get_plugin_name():
	return "Resource Editor"



func get_plugin_icon():
	return get_editor_interface().get_base_control().get_icon("CanvasItem", "EditorIcons")



func _exit_tree():
	# Erase the control from the memory.
	if dock:
		dock.queue_free()
