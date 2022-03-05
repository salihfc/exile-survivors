tool
extends Cell
class_name ResourceCell

var resource_name
var resource_path
var resource_type

signal link_pressed()


func _ready() -> void:
	set_background_color(TYPE.CELL_COLOR[TYPE.CELL.RESOURCE])



func is_valid_value(resource) -> bool:
	return resource.get_class() == resource_type



func set_value(resource) -> void:
	if resource:
		resource_type = resource.get_class()
		resource_path = resource.resource_path
		resource_name = str(resource)

	.set_value(resource)



func _on_LinkButton_pressed() -> void:
	emit_signal("link_pressed")
