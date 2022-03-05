tool
extends Resource
class_name CellData

var value
var is_resource := false


func set_resource(_resource):
	value = _resource
	is_resource = true


func set_value(_value):
	value = _value



func get_value():
	return value



func get_resource_type():
	return value.get_class()
