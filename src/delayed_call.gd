extends Timer

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _caller
var _function
var _args
var _delay

### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###
func init(caller, function, args, delay) -> void:
	_caller = caller
	_function = function
	_args = args
	_delay = delay


func _ready() -> void:
	start(_delay)

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_DelayedCall_timeout() -> void:
	if _caller:
		_caller.callv(_function, _args)
	
	queue_free()
