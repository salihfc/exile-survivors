tool
extends Cell
class_name BasicCell

export(TYPE.TYPES) var type



func set_type(_type) -> void:
	type = _type



func set_value(_value) -> void:
	if value is String:
		value = _cast(_value)
	else:
		value = _value

	label.text = str(value)
	emit_signal("cell_value_changed")



func _cast(value : String):
	if type == TYPE.TYPES.INT:
		return int(value)
	elif type == TYPE.TYPES.FLOAT:
		return float(value)
	return value



func _ready() -> void:
	set_background_color(TYPE.CELL_COLOR[TYPE.CELL.BASIC])



func is_valid_value(value) -> bool:
	if type == TYPE.TYPES.INT:
		return value.is_valid_integer()
	elif type == TYPE.TYPES.FLOAT:
		return value.is_valid_float()
	return true
