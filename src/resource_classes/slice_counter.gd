extends Resource
class_name SliceCounter
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
var _data = []
var cur_place_of_id = {} 

### VIRTUAL FUNCTIONS (_init ...) ###
func _init(slice_count) -> void:
	_data.append(range(slice_count))
	for i in slice_count:
		set_place(i, 0)


### PUBLIC FUNCTIONS ###
func get_id() -> int:
	var t = 0
	while _data[t].size() == 0:
		t += 1
	var id = _data[t].back()
	move_id(id, t+1)
	return id


func set_place(id, new_place) -> void:
	cur_place_of_id[id] = new_place


func get_place(id) -> int:
	return cur_place_of_id[id]


func release_id(id : int, times : int = 1) -> void:
	move_id(id, get_place(id) - times)


func move_id(id:int, to:int) -> void:
	var place = get_place(id)
	_data[place].erase(id)
	
	while _data.size() <= to:
		_data.append([])

	_data[to].append(id)
	cur_place_of_id[id] = to

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
