tool
extends Control

const TablePrefab =\
	preload("res://addons/resource_table/subscenes/Table.tscn")

const TabPrefab	=\
	preload("res://addons/resource_table/subscenes/ResourcesTab.tscn")

onready var tabContainer = $Panel/VBoxContainer/ResourcesTab
onready var status = $Panel/VBoxContainer/Menu/ReloadButton/StatusIndicator
onready var resourceCreationDialog = $ResourceCreationDialog

signal reload_requested()
signal inspect_requested(object)


func _enter_tree() -> void:
	TYPE.resources_by_type.clear()
	print ("DOCK INIT")
	# SCAN THE PROJECT FOLDER
	# FIND ALL tres files
	# FOR EACH TYPE OF RESOURCE CREATE TABLE
	# FOR EACH RESOURCE CREATE A ROW ON THE CORRESPONDING TABLE



func init(resource_paths : Array) -> void:
	TYPE.resources_by_type.clear()
	TYPE.clear_children_of_node(tabContainer)
#
	prepare_data(resource_paths)

	# Creating Tables
	for type in TYPE.resources_by_type:
		var tab_for_type = find_or_create_tab_of_type(type)
		LOG.pr(0, "tab for type (%s) created (%s)" % [type, tab_for_type])

		var need_table	= true
		var extra_id	= 0
		while need_table:
			var table_for_type = TablePrefab.instance()
			table_for_type.name = "     " + str(extra_id) + "     "
#			if extra_id:
#				table_for_type.name = table_for_type.name + "_" + str(extra_id)

			tab_for_type.add_child(table_for_type)
			table_for_type.connect("focus_on_cell_requested",
					self,
					"_focus_on_cell_requested")

			table_for_type.connect("inspect_resource_requested",
					self,
					"_on_inspect_resource_requested")
			
			need_table = table_for_type.init(TYPE.resources_by_type[type],
					extra_id)

			extra_id += 1
		
		if tab_for_type.get_child_count() == 1:
			tab_for_type.tabs_visible = false



func find_or_create_tab_of_type(type):
	var class_list = TYPE.get_class_list(type)

	# remove MyRes, all resources should inherit from anyways
	if class_list.back() == "MyRes":
		class_list.pop_back() 
	class_list.invert()

	var cur_tab = tabContainer
	for res_type in class_list:
		var tab = get_or_create_tab(cur_tab, res_type)
		cur_tab = tab
	return cur_tab



func get_or_create_tab(parent_tab, res_type):
	
	var child = parent_tab.get_node_or_null(res_type)
	if child == null:
		child = TabPrefab.instance()
		child.name = res_type
		parent_tab.add_child(child)

	return child



func prepare_data(resource_paths) -> void:
	for res_path in resource_paths:
		var res = load(res_path) 
		var type = res.get_class()

		if not type in TYPE.resources_by_type:
			TYPE.resources_by_type[type] = []
		TYPE.resources_by_type[type].append(res)

	for type in TYPE.resources_by_type.keys():
		var ex = TYPE.resources_by_type[type].back()

		TYPE.resource_base_classes[type] = null
		if ex.has_method("get_base"):
			TYPE.resource_base_classes[type] = ex.get_base()
	

	prints ("---------------------\n")
	prints ("Resource types found: (%s)" % [TYPE.resources_by_type.size()])
	for type in TYPE.resources_by_type.keys():
		prints (type, TYPE.get_class_list(type, TYPE.resource_base_classes))
	prints ("\n---------------------\n")



func get_current_table():
	var tab = tabContainer
	while tab is TabContainer:
		tab = tab.get_current_tab_control()
	return tab



func update_resource(path, resource):
	ResourceSaver.save(path, resource)



func _on_inspect_resource_requested(_resource) -> void:
	emit_signal("inspect_requested", _resource)



func _focus_on_cell_requested(cell) -> void:
	return



func _exit_tree() -> void:
	print ("DOCK DELETE")



func _on_ReloadButton_pressed() -> void:
	status.set_busy()



func on_reload_done() -> void:
	status.set_done()
	


func _on_StatusIndicator_status_busy() -> void:
	call_deferred("emit_signal", "reload_requested")



func _on_CreateResourceClassButton_pressed() -> void:
	resourceCreationDialog.show()
	var base_types = TYPE.resources_by_type.keys()
	base_types.sort()
	base_types.push_front("MyRes")
	resourceCreationDialog.init(base_types)



func _on_CreateResourceButton_pressed() -> void:
	# Show dialog
	pass



func _on_LineEdit_text_entered(new_text: String) -> void:
	var current_table = get_current_table()
	var type = current_table.sample_resource_type
	
	print (JSON.print(TYPE.resources_by_type, "\t"))
	var dict = TYPE.resources_by_type
	var _script = dict[type].front().script
	var new_resource = _script.new()

	var _name = new_text
	new_resource.resource_name	= _name
	var FOLDER = "res://src/mock/mock_data/"
	var path = FOLDER + _name + ".tres"
	
	if path.is_valid_filename():
		print (path, new_resource)
		ResourceSaver.save(path, new_resource)
		LOG.pr(0, "(%s) type exist (%s :: %s)" %
				[type, new_resource.resource_name, new_resource])
#		resourceNameDialog.hide()
#	else:
#		resourceNameDialog.lineEdit = ""

