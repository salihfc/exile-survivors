extends Resource
class_name BasicCache
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _cached = {}

### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func clear() -> void:
	_cached.clear()

func cache(key : String, value) -> void:
	_cached[key] = value


func invalidate(key : String) -> void:
	_cached.erase(key)


func get_cached(key : String):
	if key in _cached:
		return _cached[key]
	return null

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
