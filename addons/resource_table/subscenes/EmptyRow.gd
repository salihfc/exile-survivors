tool
extends Row
class_name EmptyRow

func get_class(): return "EmptyRow"
func is_class(name): return name == "EmptyRow" or .is_class(name) 

var col_count := 0


func init_empty(_col_count) -> void:
	col_count = _col_count



func _ready():
	for _i in range(max(MIN_CELL_COUNT, col_count)):
		add_emtpy_cell()



func init(_resource, _resource_variables = []) -> void:
	return



func init_as_column_names(_column_names, filler_size = 0) -> void:
	return
