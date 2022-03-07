extends Resource
class_name WeightedRandom

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _weights := []
var _sum := 0
### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###
func _init(weights : Array) -> void:
	_weights = weights
	for weight in weights:
		_sum += weight


### PUBLIC FUNCTIONS ###
func rand() -> int:
	var p = randi() % (_sum)
	
	var cur = 0
	while p >= _weights[cur]:
		p -= _weights[cur]
		cur += 1
	return cur

# Debug function
func do_test(q : int = 100) -> void:
	var expected = []
	for w in _weights:
		expected.append(float(w) / _sum)
	
	
	var freq = []
	for _i in _weights.size():
		freq.append(0)
	
	for _i in range(q):
		var x = rand()
		freq[x] += 1

	var freq_p = []
	for i in freq.size():
		freq_p.append(freq[i] / float(q))


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
