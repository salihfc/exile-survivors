extends Enemy
class_name EnemyBatEye
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const SHADER_PARAM_DAMAGE_TAKEN_MODULATE = "damage_taken_modulate"
const SHADER_PARAM_OUTLINE_COLOR = "outline_color"

var TIER_COLORS = [
	Color.black,
	Color.aquamarine,
	Color.greenyellow,
	Color.orangered,
]

const TIER_SCALES = [
	1.0,
	1.1,
	1.3,
	1.6,
]

var tier_selection_weighted_random = WeightedRandom.new([10.0, 2.0, 1.0, 1.1])


### EXPORT ###
export(Color) var frozen_modulate;
export(Color) var damage_taken_modulate;

# warning-ignore:unused_class_variable
export(int) var tier := 0 # 0 is normal 1,2,3.. -> elite enemies with tiers
### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var animSprite = $VisualBodyCenter/AnimatedSprite as AnimatedSprite
onready var animTween = $AnimTween as Tween
onready var animPlayer = $AnimationPlayer as AnimationPlayer


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	_main_sprite = animSprite
	animSprite.material = animSprite.material.duplicate()
	
	# set random tier
	tier = tier_selection_weighted_random.rand()
	
	# Give Elite enemy outlines via shader
	_set_scaled_stats()

	LOG.pr(1, "Enemy (%s) created" % [tier])

# warning-ignore:unused_argument
func _process(delta: float) -> void:
#	if abs(_velocity.x) > FLIP_THRESHOLD:
#		animSprite.flip_h = _velocity.x < 0.0

	if _target:
		var diff = (_target.global_position.x - global_position.x)
		if abs(diff) > FLIP_THRESHOLD:
			animSprite.flip_h = diff < 0.0

### PUBLIC FUNCTIONS ###
# Overriding Enemy.take_damage
func take_damage(amount : float, push_force := Vector2.ZERO) -> void:
	.take_damage(amount, push_force)
	
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
	animSprite.material.set_shader_param(SHADER_PARAM_DAMAGE_TAKEN_MODULATE, color)
#	print ("called set shader param")


### PRIVATE FUNCTIONS ###
func _set_scaled_stats() -> void:
	base_max_hp = base_max_hp * pow(1.25, tier)
	base_damage = base_damage * pow(1.1, tier)
	base_exp = base_exp * (float(tier) + 1.0)
	animSprite.material.set_shader_param(SHADER_PARAM_OUTLINE_COLOR, TIER_COLORS[tier])
	scale *= Vector2.ONE * TIER_SCALES[tier]


func _die():
	uiElementsContainer.hide()
	animPlayer.play("death")


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


func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "death":
		._die()
