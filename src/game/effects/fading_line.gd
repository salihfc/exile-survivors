extends Line2D

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const START_INDEX = 0
const END_INDEX = 1

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _start : Vector2
var _end : Vector2
var _duration : float
var _delay : float
var _appear : float

### ONREADY VAR ###
onready var tween = $Tween as Tween

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	var appearing_duration = _appear

	tween.interpolate_property(
			self, "modulate",
			self.modulate, Color.white,
			appearing_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			_delay
	)
	
# warning-ignore:unused_variable
	var final_color = Color(1.0, 1.0, 1.0, 0.5)
	
	tween.interpolate_property(
			self, "modulate",
			Color.white, final_color,
			_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			_delay + appearing_duration + 0.01
	)

	tween.interpolate_method(
			self, "_update_end",
			_start, _end,
			_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			_delay
	)

	tween.interpolate_method(
			self, "_update_start",
			_start, _end,
			appearing_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			_delay + _duration
	)

	tween.start()

### PUBLIC FUNCTIONS ###
func init(
		start_pos : Vector2, end_pos : Vector2,
		duration : float, appear : float, starting_delay : float) -> void:

	_start = start_pos
	_end = end_pos
	_duration = duration
	_delay = starting_delay
	_appear = appear
	modulate = Color.transparent
	
	clear_points()
	add_point(start_pos)
	add_point(end_pos)
	
#	LOG.pr(1, "FadingLine(%s, %s)" % [start_pos, end_pos])


### PRIVATE FUNCTIONS ###
func _update_start(pos) -> void:
	set_point_position(START_INDEX, pos)


func _update_end(pos) -> void:
	set_point_position(END_INDEX, pos)

### SIGNAL RESPONSES ###


func _on_Tween_tween_all_completed() -> void:
	queue_free()
