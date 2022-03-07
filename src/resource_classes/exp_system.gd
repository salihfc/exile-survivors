extends Resource
class_name ExpSystem

"""

"""

### SIGNAL ###
signal level_up(new_level) # exp overflow handled and signaled seperately
signal exp_changed(new_exp, max_exp)

### ENUM ###


### CONST ###
const BASE_EXP = 5.0

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _required_exp_cache = {}
var _current_level = 0
var _current_exp = 0
### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###
func _init(max_level :int= 100) -> void:
	for i in range(0, max_level):
		_required_exp_cache[i] = _get_level_up_required_exp(i)


### PUBLIC FUNCTIONS ###
func gain_exp(amount) -> void:
	_current_exp += amount
	
	if _current_exp >= _required_exp_cache[_current_level]:
		_current_exp -= _required_exp_cache[_current_level]
		_current_level += 1
		emit_signal("level_up", _current_level)

	emit_signal("exp_changed", _current_exp, _required_exp_cache[_current_level])


func get_level():
	return _current_level


### PRIVATE FUNCTIONS ###
func _get_level_up_required_exp(current_level : float) -> float:
	return (pow(1.08, current_level) - current_level/24.0) * BASE_EXP


### SIGNAL RESPONSES ###
