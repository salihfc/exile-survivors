extends Node2D
class_name FloatingText
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const GRAV = Vector2(0.0, 10.0)

### EXPORT ###
export(Color) var starting_color = Color.aliceblue
export(Color) var end_color = Color.aliceblue

### PUBLIC VAR ###


### PRIVATE VAR ###
var _vel : Vector2
var _from : Vector2
var _text : String
var _duration : float

### ONREADY VAR ###
onready var rich_text_label = $RichTextLabel as RichTextLabel
onready var tween = $Tween as Tween



### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	throw()


func _process(delta: float) -> void:
	if visible:
		_vel += GRAV * delta
		global_position += _vel * delta + GRAV * delta * delta


### PUBLIC FUNCTIONS ###
func init(text : String, from : Vector2, with_vel : Vector2, duration : float) -> void:
	_text = text
	_vel = with_vel
	_from = from
	_duration = duration


func throw() -> void:
	rich_text_label.bbcode_text = _text
	global_position = _from

	UTILS.interpolate_method_to_and_back(
			tween,
			self, "set_modulate",
			end_color, starting_color,
			_duration * 0.3, _duration * 0.7
	)

	tween.interpolate_property(
			self, "scale", 
			scale, Vector2.ONE * 1.2, 
			_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)
	
	
	tween.start()
	show()


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_Tween_tween_all_completed() -> void:
	queue_free()
	pass # Replace with function body.
