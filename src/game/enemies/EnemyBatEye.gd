extends Enemy
class_name EnemyBatEye
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const FLIP_THRESHOLD = 20.0
const TIER_COLORS = [
	Color.transparent,
	Color.aquamarine,
	Color.greenyellow,
	Color.rebeccapurple,
]

var tier_selection_weighted_random = WeightedRandom.new([4.0, 3.0, 2.0, 1.0])


### EXPORT ###
export(Color) var frozen_modulate;
export(Color) var damage_taken_modulate;

# warning-ignore:unused_class_variable
export(int) var tier := 0 # 0 is normal 1,2,3.. -> elite enemies with tiers
### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var animSprite = $AnimatedSprite as AnimatedSprite
onready var animTween = $AnimTween as Tween


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	_main_sprite = animSprite
	animSprite.material = animSprite.material.duplicate()
	
	# set random tier
	tier = tier_selection_weighted_random.rand()
	
	# Give Elite enemy outlines via shader
	animSprite.material.set_shader_param("outline_color", TIER_COLORS[tier])
	_set_scaled_stats()

	LOG.pr(1, "Enemy (%s) created" % [tier])


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	if abs(_velocity.x) > FLIP_THRESHOLD:
		animSprite.flip_h = _velocity.x < 0.0


### PUBLIC FUNCTIONS ###
# Overriding Enemy.take_damage
func take_damage(amount : float) -> void:
	_set_hp(_hp - amount)
	
#	animTween.remove_all()

	var to_red_duration = 0.1
	var to_white_duration = 0.1
	
	UTILS.interpolate_method_to_and_back(
		animTween,
		self, "set_shader_damage_taken_color",
		Color.white, damage_taken_modulate,
		to_red_duration, to_white_duration
	)


func set_shader_damage_taken_color(color) -> void:
	animSprite.material.set_shader_param("DAMAGE_TAKEN_COLOR", color)
#	print ("called set shader param")


### PRIVATE FUNCTIONS ###
func _set_scaled_stats() -> void:
	base_max_hp = base_max_hp * pow(1.25, tier)
	base_damage = base_damage * pow(1.1, tier)
	base_exp = base_exp * tier



### SIGNAL RESPONSES ###
func _on_freeze_for(time : float) -> void:
	._on_freeze_for(time)
	var to_white_duration = 0.1
	var to_frozen_color_duration = time - to_white_duration
	
	UTILS.interpolate_method_to_and_back(
		animTween,
		self, "set_shader_damage_taken_color",
		Color.white, frozen_modulate,
		to_frozen_color_duration, to_white_duration
	)
	
	animSprite.playing = false


func _on_FreezeTimer_timeout() -> void:
	._on_FreezeTimer_timeout()
	animSprite.playing = true


func _on_AnimTween_tween_completed(object: Object, key: NodePath) -> void:
	animTween.remove(object, key)
