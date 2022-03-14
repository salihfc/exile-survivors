extends Enemy
class_name EnemyBatEye
"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###



### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###


### VIRTUAL FUNCTIONS (_init ...) ###


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
