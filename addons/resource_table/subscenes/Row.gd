tool
extends Control
class_name Row

const Filler		= preload("res://addons/resource_table/subscenes/Filler.tscn")
const CellPrefab = preload("res://addons/resource_table/subscenes/Cell.tscn")
const EmptyCell		= preload("res://addons/resource_table/subscenes/cells/EmptyCell.tscn")
const BasicCell		= preload("res://addons/resource_table/subscenes/cells/BasicCell.tscn")
const ResourceCell	= preload("res://addons/resource_table/subscenes/cells/ResourceCell.tscn")

const COLUMN_NAMES_BG_COLOR 	:= Color.darkslateblue
const MIN_CELL_COUNT			:= 5
var UNIT_NAME_COLUMN_BG_COLOR	:= Color.black.lightened(0.3)

onready var container = $HBoxContainer

signal cell_selected(cell)
signal cell_link_selected(cell)
signal row_resource_inspect_requested(_resource)

var resource_path : String
var resource
var resource_variables 


var is_column_names_row := true
var column_names		:= []



func init(_resource, _resource_variables = []) -> void:
	resource_path = _resource.resource_path
	resource = _resource
	resource_variables = _resource_variables
	is_column_names_row = false



func init_as_column_names(_column_names, filler_size = 0) -> void:
	column_names			= _column_names

	for column in column_names:
		 # To get immutable cell 'null' used
		var cell = add_basic_cell(TYPE.TYPES.STRING, column, column)
		cell.make_immutable()
		cell.set_background_color(TYPE.CELL_COLOR[TYPE.CELL.COL_NAME])


	var pad_cells = MIN_CELL_COUNT - container.get_child_count()
	for _i in range(pad_cells):
		add_emtpy_cell()


	if filler_size > 0:
		var filler = Filler.instance()
		filler.set_filler(Vector2(filler_size - get_seperation(), 0))
		container.add_child(filler)




func get_seperation():
#	var sep = container.get("custom_constants/seperation")
#	print ("SEP: (%s)" % [sep])
	return 4



func _ready() -> void:

	if not is_column_names_row and not get_class() == "EmptyRow":
		# FIRST CELL OF THE ROW
		var resource_name_cell = add_basic_cell(TYPE.TYPES.RESOURCE_PATH, resource, "resource_name")
#		resource_name_cell.make_immutable()


		for var_name in resource_variables:
			var variable = TYPE.get_script_variable(resource, var_name)
			var value = resource.get(var_name)
			
			if value is Resource:
				add_resource_cell(value, var_name)
			else:
				var type  = variable["type"]
				add_basic_cell(type, value, var_name)


		var pad_cells = MIN_CELL_COUNT - container.get_child_count()
		for _i in range(pad_cells):
			add_emtpy_cell()



func add_emtpy_cell():
	var cell = EmptyCell.instance()
	container.add_child(cell)
	return cell



func add_basic_cell(type, value, col_name):
	var cell = BasicCell.instance()
	cell.set_type(type)
	container.add_child(cell)
	
	connect_cell(cell)
	
	cell.set_value(value)
	cell.set_col_name(col_name)

	return cell



func add_resource_cell(resource, col_name):
	var cell = ResourceCell.instance()
	container.add_child(cell)
	
	connect_cell(cell)
	cell.connect("link_pressed", self, "_on_cell_link_pressed", [cell])
	
	cell.set_value(resource)
	cell.set_col_name(col_name)
	
	return cell



func connect_cell(cell) -> void:
	cell.connect("cell_selected", self, "_on_cell_selected", [cell])
	cell.connect("cell_value_changed", self, "_on_cell_value_changed", [cell])




func _on_cell_selected(cell) -> void:
	prints("CELL SELECTED IN ROW (%s)" % [self])
	if cell.type == TYPE.TYPES.RESOURCE_PATH:
		emit_signal("row_resource_inspect_requested", resource)
	else:
		emit_signal("cell_selected", cell)



func _on_cell_link_pressed(cell) -> void:
	emit_signal("cell_link_selected", cell)



func _on_cell_value_changed(cell) -> void:
	if resource:
		resource.set(cell.col_name, cell.get_value())
		ResourceSaver.save(resource_path, resource)
