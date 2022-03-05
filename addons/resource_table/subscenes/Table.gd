tool
extends Control


const MAX_COLS_PER_TABLE = 8
const MIN_ROWS			 = 6

const RowPrefab = preload("res://addons/resource_table/subscenes/Row.tscn")
const EmptyRow	= preload("res://addons/resource_table/subscenes/EmptyRow.tscn")

onready var colNamesRow			= $VBoxContainer/ColNamesRow
onready var container			= $VBoxContainer/ScrollContainer/VBoxContainer
onready var scrollContainer		= $VBoxContainer/ScrollContainer
onready var textInput			= $InputPopup
onready var resourceSelector	= $QuickResourceSelection

var last_selected_cell = null
var sample_resource_type = null


signal focus_on_cell_requested(cell)
signal inspect_resource_requested(resource)


func _ready() -> void:
	scrollContainer.set_follow_focus(true)



func init(resources, extra_id := 0) -> bool:
	assert(resources.size())
	var sample_resource = resources[0]
	sample_resource_type = sample_resource.get_class()

	var var_names = TYPE.get_script_variable_names(sample_resource, TYPE.IGNORED_TYPES) as Array
	var_names = var_names.slice(extra_id * MAX_COLS_PER_TABLE, (extra_id+1) * MAX_COLS_PER_TABLE - 1)
	
	# INIT FIRST ROW (COLUMN NAMES)
	var col_names = TYPE.get_col_names(sample_resource, var_names, TYPE.IGNORED_TYPES)
	col_names.push_front("resource name")
#	print ("COL NAMES:", col_names)
	
	var filler_size = scrollContainer.get_v_scrollbar().rect_size.x
	colNamesRow.init_as_column_names(col_names, filler_size)

	# ADD A ROW FOR EACH RESOURCE
	# POP resource name
	for resource in resources:
		add_row(resource, var_names)
	#
	var extra_rows = MIN_ROWS - resources.size()
	for _i in range(extra_rows):
		add_empty_row(col_names.size())
	
	var need_extra_table = ((extra_id + 1) * MAX_COLS_PER_TABLE) <= var_names.size()
	return need_extra_table



func _process(delta: float) -> void:
	if Input.is_key_pressed(KEY_1):
		scrollContainer.scroll_vertical += 50 * delta



func add_row(resource, variable_names) -> void:
	var row = RowPrefab.instance()
	row.init(resource, variable_names)
	row.connect("cell_selected",		self, "_on_cell_selected")
	row.connect("cell_link_selected",	self, "_on_cell_link_pressed")
	row.connect("row_resource_inspect_requested", self, "_on_resource_inspect_requested")
	container.add_child(row)



func add_empty_row(col_count) -> void:
	var row = EmptyRow.instance()
	row.init_empty(col_count)
	container.add_child(row)



func get_row_with_resource_name(resource_name):
	for row in container.get_children():
		if str(row.resource) == resource_name:
			return row
	return null



func ensure_row_visible(row) -> void:
	return
	row.grab_focus()
	
	var row_height = row.rect_size.y
	var row_idx = row.get_index() 
	var scroll_amount = row_idx * row_height
	scrollContainer.scroll_vertical += scroll_amount



func _on_resource_inspect_requested(_resource) -> void:
	emit_signal("inspect_resource_requested", _resource)



func _on_cell_link_pressed(cell) -> void:
	emit_signal("focus_on_cell_requested", cell)



func _on_cell_selected(cell) -> void:
	last_selected_cell = cell
	
	LOG.pr(0, "cell is resource : (%s)" % [cell is ResourceCell])
	
	if cell is ResourceCell: # Cell contains subresource
		resourceSelector.init(TYPE.resources_by_type[cell.resource_type])
		resourceSelector.show()
		resourceSelector.clear()
		resourceSelector.focus_on_line_edit()
		
	else:
		textInput.show()
		textInput.clear()
		textInput.focus_on_line_edit()



func _on_LineEdit_text_entered(text) -> void:
	
	if not last_selected_cell.is_valid_value(text):
		return

	last_selected_cell.set_value(text)
	textInput.hide()



func _on_QuickResourceSelection_word_selected(word) -> void:

	
	var resource = TYPE.get_resource_with_name(
			word, 
			last_selected_cell.resource_type,
			TYPE.resources_by_type)

	LOG.pr(0, "last selected res: name(%s),\nres(%s),\ntype(%s)"\
			% [word, resource, last_selected_cell.resource_type])

	
	if not last_selected_cell.is_valid_value(resource):
		LOG.pr(0, "resource was not valid")
		return

	last_selected_cell.set_value(resource)
	resourceSelector.hide()



func _on_InputPopup_aborted() -> void:
	textInput.hide()



func _on_QuickResourceSelection_aborted() -> void:
	resourceSelector.hide()



func _on_ScrollContainer_scroll_ended() -> void:
	prints ("scroll END:", scrollContainer.scroll_vertical)



func _on_ScrollContainer_scroll_started() -> void:
	prints ("scroll start:", scrollContainer.scroll_vertical)
