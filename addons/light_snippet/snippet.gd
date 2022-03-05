tool
extends Resource
class_name Snippet

func get_class(): return "Snippet"
func is_class(name): return name == "Snippet" or .is_class(name) 
func _to_string() -> String: return resource_path.get_file().trim_suffix(".tres")


export(String) var _name
export(String, MULTILINE) var _text


func _init(name = "", text = "") -> void:
	_name = name
	_text = text


func get_name() -> String:
	return _name


func get_data() -> String:
	return _text
