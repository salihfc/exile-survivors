tool
extends Node

var IGNORED_TYPES = [Texture, AudioEffect, AudioStream]

enum TYPES {
	INT				= TYPE_INT,
	FLOAT			= TYPE_REAL,
	STRING			= TYPE_STRING,
	RESOURCE_PATH	= TYPE_NODE_PATH,
	RESOURCE		= TYPE_OBJECT,
}


const NAMES = {
	TYPE_INT		: "INT",
	TYPE_REAL		: "FLOAT",
	TYPE_STRING		: "STRING",
	TYPE_NODE_PATH	: "RESOURCE_PATH",
	TYPE_OBJECT		: "RESOURCE",
}

const DEFAULTS = {
	TYPE_INT		: "0",
	TYPE_REAL		: "0.0",
	TYPE_STRING		: "str",
	TYPE_NODE_PATH	: "path",
	TYPE_OBJECT		: "resource",
}

enum CELL {
	DEFAULT,
	BASIC,
	RESOURCE,
	COL_NAME,
}

var CELL_COLOR := {
	CELL.DEFAULT	: Color("00b4b4b4"),
	CELL.BASIC		: Color.black.lightened(0.1),
	CELL.RESOURCE	: Color.darkslateblue,
	CELL.COL_NAME	: Color("#673d8c")
}

class CALL:
	var node
	var func_name
	var args
	var wait
	
	func _init(_node, _func_name, _args, _wait) -> void:
		node = _node
		func_name = _func_name
		args = _args
		wait = _wait
	
	func execute():
		node.callv(func_name, args)

var call_queue = []


static func schedule_call(node, func_name, args, wait_frames = 0, queue = call_queue):
	if wait_frames:
		queue.append(CALL.new(node, func_name, args, wait_frames))
	else:
		node.callv(func_name, args)



#func _process(delta: float) -> void:
#	for call in call_queue:
#		if call.wait == 0:
#			call.execute()
#		else:
#			call.wait -= 1


# GLOBAL REFS TO RESOURCES
var resource_base_classes	:= {} 
var resources_by_type		:= {}


static func is_resource_inherited_from(resource, base_resources):
	if resource == null:
		return true

	if resource is Resource:
		print (resource.get_class(), base_resources)

	for res in base_resources:
		if resource is res:
#			prints ("%s is %s" % [resource, res])
			return true
	return false



func get_resource_with_name(resource_name, resource_type, resource_dict):
	var resources = resource_dict[resource_type]
	for resource in resources:
		if str(resource) == resource_name:
			return resource
	return null



func typename(type_idx) -> String:
	if type_idx in NAMES:
		return NAMES[type_idx]
	return "unknown"



func get_script_variable(resource, _name):
	for prop in resource.get_property_list():
		if prop["name"] == _name:
			return prop
	return null



func get_prop_dicts(resource):
	var dict = {}
	var properties = resource.get_property_list()
	for prop in properties:
		if prop["name"]:
			dict[prop["name"]] = prop
	return dict



func get_col_names(resource, var_names, ignored_types = []):
	var col_names = []
	var properties = get_prop_dicts(resource)

	for var_name in var_names:
		var prop = properties[var_name]
		var col_name = var_name
		var prop_value = resource.get(var_name)
	
		if is_resource_inherited_from(prop_value, ignored_types):
			continue

		if var_name == col_name and "type" in prop:
			col_name += " [%s]" % [typename(prop["type"])]
		col_names.append(col_name)

	return col_names




func get_script_variable_names(resource, ignored_types = []) -> Array:
	var vars = []

	for prop_dict in resource.get_property_list():
		var prop_name = prop_dict["name"]
		if "usage" in prop_dict and int(prop_dict["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			var prop = resource.get(prop_name)
			if not is_resource_inherited_from(prop, ignored_types):
				vars.append(prop_name)

	return vars



func clear_children_of_node(node) -> void:
	if node:
		var children = node.get_children()
		for child in children:
			node.remove_child(child)
			child.queue_free()
	else:
		push_warning("clear_children_of_node called on [NULL]")



# from derived -> base ex. [character, unit, myres, resource], ends with native a class
func get_class_list(type, base_classes = resource_base_classes) -> Array:
	var list = []
	var cur = type
	
	while cur != null:
		list.append(cur)
		cur = base_classes.get(cur)
	
	return list
