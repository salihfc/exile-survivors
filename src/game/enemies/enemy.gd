extends Node2D
class_name Enemy

"""

"""

### SIGNAL ###
signal died(exp_rewarded_to_player)

### ENUM ###


### CONST ###
const CONVERGENCE_THRESHOLD = 100.0
const CONVERGENCE_SPEED_FACTOR = 4.0

const MAX_VEL	  	  = 200.0
const MAX_STEER_FORCE = 1000.0
const ATTACK_CD = 1.0

### EXPORT ###
export(float) var base_max_hp := 100.0
export(float) var base_damage := 10.0
export(float) var base_exp := 2.0

### PUBLIC VAR ###
var max_hp

### PRIVATE VAR ###
# Physics
var _velocity := Vector2.ZERO
# Battle
var _hp := 1.0
# warning-ignore:unused_class_variable
var _main_sprite : CanvasItem
var _target = null

# FLAG
var _frozen := false

### ONREADY VAR ###
onready var hpBar = $Hp_bar as HpBar
onready var hitTimer = $HitTimer as Timer
onready var hitBox = $HitBox as HitBox

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	add_to_group("enemy", true)


func _process(delta: float) -> void:
	if _target:
		_seek(_target.global_position, delta)


func _physics_process(delta: float) -> void:
	if not _frozen:
		global_position += _velocity * delta


### PUBLIC FUNCTIONS ###
func set_target(target) -> void:
	_target = target


func set_scaled_hp(player_level) -> void:
	max_hp = base_max_hp * _get_hp_scaling(player_level)
	_set_hp(max_hp)
	LOG.pr(1, "Enemy with (%s) created" % [max_hp])


func apply_force(force : Vector2) -> void:
	_velocity += force


func take_damage(amount : float) -> void:
	_set_hp(_hp - amount)


func alive() -> bool:
	return _hp > 0.0


func can_attack() -> bool:
	return is_zero_approx(hitTimer.time_left)


func attack(target) -> void:
	LOG.pr(1, "Enemy(%s) attacked (%s)" % [self.name, target])
	target.take_damage(base_damage)
	hitTimer.start(ATTACK_CD)


### PRIVATE FUNCTIONS ###
func _set_hp(new_hp) -> void:
	_hp = new_hp
	hpBar.set_bar(_hp / max_hp)
	if not alive():
		_die()


func _die():
	emit_signal("died", base_exp)
	queue_free()


func _on_freeze_for(time : float) -> void:
	assert(_main_sprite)
	var saved_modulate = _main_sprite.modulate
	_main_sprite.modulate = CONFIG.FROZEN_ENEMY_MODULATE_COLOR
	_frozen = true
	
	yield(get_tree().create_timer(time), "timeout")
	if self:
		_on_unfreeze(saved_modulate)


func _on_unfreeze(before_freeze_modulate) -> void:
	_main_sprite.modulate = before_freeze_modulate
	_frozen = false


# AI
func _seek(pos, delta) -> void:
	if global_position.distance_to(pos) < CONVERGENCE_THRESHOLD:
		_converge(pos)
		return
	
	var desired_vel = (pos - global_position).normalized() * MAX_VEL
	var force = (desired_vel - _velocity).normalized() * MAX_STEER_FORCE * delta
	_velocity += force
	_velocity = _velocity.normalized() * min(_velocity.length(), MAX_VEL)


func _converge(pos : Vector2) -> void:
	var desired := (pos - global_position) * CONVERGENCE_SPEED_FACTOR
	_velocity = desired.normalized() * min(desired.length(), MAX_VEL)
##


func _get_entities_in_hitbox() -> Array:
	var overlap = hitBox.get_overlapping_areas()
	var entities = []
	
	for area in overlap:
		var entity = area.get_parent()
		if entity:
			entities.append(entity)
	return entities


func _get_hp_scaling(level) -> float:
	return pow(level, 2.0) / 40.0 + 1


### SIGNAL RESPONSES ###


func _on_HitBox_area_entered(area: Area2D) -> void:
	
	if can_attack():
		if area is HurtBox:
			var entity = area.get_parent()
			if entity is Player:
				attack(entity)


func _on_HitTimer_timeout() -> void:
	var in_hitbox = _get_entities_in_hitbox()
	for entity in in_hitbox:
		if entity is Player:
			attack(entity)



func _on_Hurtbox_area_entered(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity is Projectile:
		take_damage(entity.get_projectile_damage())
		entity.hit_target()
