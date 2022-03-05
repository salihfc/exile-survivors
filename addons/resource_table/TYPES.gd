tool
extends Node

enum TYPES {
	INT		= TYPE_INT,
	FLOAT	= TYPE_REAL,
	STRING	= TYPE_STRING,
	PATH	= TYPE_NODE_PATH
}


const NAMES = {
	TYPE_INT		: "INT",
	TYPE_REAL		: "FLOAT",
	TYPE_STRING		: "STRING",
	TYPE_NODE_PATH	: "PATH",
}

static func typename(type_idx) -> String:
	if type_idx in NAMES:
		return NAMES[type_idx]
	return ""


static func get_script_variables(resource) -> Array:
	var vars = []
	for prop in resource.get_property_list():
		if "usage" in prop and int(prop["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			vars.append(prop)
	return vars



static func get_script_variable(resource, _name):
	for prop in resource.get_property_list():
		if "usage" in prop and int(prop["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			if prop["name"] == _name:
				return prop
	return null

static func get_prop_dict(resource):
	var dict = {}
	var properties = resource.get_property_list()
	for prop in properties:
		if prop["name"]:
			dict[prop["name"]] = prop
	return dict


static func get_col_names(resource, var_names):
	var col_names = []

	var properties = get_prop_dict(resource)

	for var_name in var_names:
		if var_name in properties:
			var prop = properties[var_name]
			if "usage" in prop and int(prop["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
				var col_name = var_name
				if var_name == col_name and "type" in prop:
					col_name += " [%s]" % [typename(prop["type"])]
				col_names.append(col_name)

	return col_names


static func get_script_variable_names(resource) -> Array:
	var vars = []
	for prop in resource.get_property_list():
		if "usage" in prop and int(prop["usage"]) & PROPERTY_USAGE_SCRIPT_VARIABLE:
			vars.append(prop["name"])
	return vars


