extends Node

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const SLICE_COUNT = 5

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _enemy_slices = SliceCounter.new(SLICE_COUNT)

### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
# warning-ignore:unsafe_method_access
	LOG.pr(3, "TIME_SLICER READY")
# warning-ignore:unused_argument
#func _physics_process(delta: float) -> void:
#	prints (_enemy_slices._data, "->", enemy_count_in_slices())


### PUBLIC FUNCTIONS ###
func enemy_count_in_slices() -> int:
	var ct = 0
	for i in _enemy_slices._data.size():
		ct += i * _enemy_slices._data[i].size()
	return ct


func get_id_for_entity(entity) -> int:
	var given_id = _enemy_slices.get_id()
	UTILS.bind(
			entity, "died",
			self, "_on_entity_died", [given_id])
	return given_id


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
# warning-ignore:unused_argument
func _on_entity_died(base_exp, given_id) -> void:
	_enemy_slices.release_id(given_id)
