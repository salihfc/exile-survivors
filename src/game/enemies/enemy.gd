extends Node2D
class_name Enemy

"""

"""

### SIGNAL ###
signal died(exp_rewarded_to_player)
signal damage_taken(amount)
### ENUM ###


### CONST ###
# VISUAL
const FLIP_THRESHOLD = 20.0

# AI
const CONVERGENCE_THRESHOLD = 100.0
const CONVERGENCE_SPEED_FACTOR = 4.0

# PHYS
const MAX_VEL	  	  = 200.0
const MAX_STEER_FORCE = 1000.0

# GAME
const ATTACK_CD = 1.0

### EXPORT ###
export(Resource) var stats

export(float) var base_max_hp := 100.0
export(float) var base_damage := 10.0
export(float) var base_exp := 2.0


### PUBLIC VAR ###

### PRIVATE VAR ###
# Physics
var _velocity := Vector2.ZERO

# warning-ignore:unused_class_variable
var _main_sprite : CanvasItem
var _target = null
var _level = 0

# FLAG
var _frozen := false

### ONREADY VAR ###
onready var uiElementsContainer = $UiElements as Control
onready var hpBar = $UiElements/Hp_bar as HpBar
onready var hitBox = $Areas/HitBox as HitBox

onready var hitTimer = $Timers/HitTimer as Timer
onready var freezeTimer = $Timers/FreezeTimer as Timer

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


func set_level(player_level) -> void:
	_level = player_level
	var scaled_max_hp = base_max_hp * _get_hp_scaling(player_level)
	stats.set_stat(Stats.MAX_HP, scaled_max_hp)
	stats.set_stat(Stats.HP, scaled_max_hp)

#	LOG.pr(1, "Enemy with (%s) created" % [max_hp])


func apply_force(force : Vector2) -> void:
	# Normally force should be divided by mass, currently every object has same mass
	_velocity += force


func take_damage(amount : float, push_force := Vector2.ZERO) -> void:
	apply_force(push_force)
	emit_signal("damage_taken", global_position, amount)
	
	var reduced_amount = _apply_incoming_damage_modifiers(amount)
	_set_hp(stats.get_stat(Stats.HP) - reduced_amount)


func alive() -> bool:
	return stats.get_stat(Stats.HP) > 0.0


func can_attack() -> bool:
	return is_zero_approx(hitTimer.time_left)


func attack(target) -> void:
	LOG.pr(1, "Enemy(%s) attacked (%s)" % [self.name, target])
	target.take_damage(base_damage)
	hitTimer.start(ATTACK_CD)


### PRIVATE FUNCTIONS ###
func _set_hp(new_hp) -> void:
	stats.set_stat(Stats.HP, new_hp)
	hpBar.set_bar(stats.get_hp_perc())
	if not alive():
		_die()


func _die():
	emit_signal("died", base_exp)
	base_exp = 0.0
	queue_free()


func _on_freeze_for(time : float) -> void:
	assert(_main_sprite)
	_frozen = true
	freezeTimer.start(time)


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

# SCALING
func _get_hp_scaling(level) -> float:
	return pow(level, 2.0) / 40.0 + 1


func _get_scaled_def() -> float:
	var base_def = stats.get_stat(Stats.DEF)
	return base_def + _level


# DAMAGE CALC
func _apply_incoming_damage_modifiers(amount : float) -> float:
	amount -= _get_scaled_def()
	return amount



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
	if area is HitBox:
		var hitbox = area as HitBox
		var projectile = hitbox.get_node(hitbox.parent_path)
		if projectile is Projectile:
			take_damage(projectile.get_projectile_damage(), projectile.get_push_force())
			projectile.hit_target()


func _on_FreezeTimer_timeout() -> void:
	_frozen = false
