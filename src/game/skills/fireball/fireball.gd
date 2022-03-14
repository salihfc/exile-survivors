extends Skill
class_name Fireball

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const ProjectilePrefab = preload("res://src/game/skills/fireball/fireball_projectile.tscn")

### EXPORT ###
export(float) var speed := 400.0
export(int) var max_pierce := 0
export(int) var projectile_count = 1
export(float) var spread_angle # Angle of the whole cone


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var createdProjectiles = $CreatedProjectiles as Node2D


### VIRTUAL FUNCTIONS (_init ...) ###

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_e"):
		var aug = MajorAugmentFireballProjectileCount.new()
		apply_augment(aug)

### PUBLIC FUNCTIONS ###



### PRIVATE FUNCTIONS ###
func _cast() -> void:
	var proj_count = _get_projectile_count()
	var base_velocity = _get_projectile_velocity()
	var damage = _get_damage()
	var pierce = _get_max_pierce()
	var force = _get_push_force()
	
	if is_zero_approx(base_velocity.length()):
		return
	
	if proj_count > 0:
		_create_projectile(base_velocity, damage, pierce, force)

	var base_rotation = deg2rad(spread_angle)
	
	if proj_count > 1:
		for i in range(1, proj_count):
			var side = i % 2
			# warning-ignore:integer_division
			var idx = (i+1) / 2
			var rotation_amount = float(1 - 2 * side) * idx * base_rotation
			var vel = base_velocity.rotated(rotation_amount)
			_create_projectile(vel, damage, pierce, force)


func _create_projectile(projectile_velocity, damage, pierce, force) -> void:
	var new_projectile = ProjectilePrefab.instance()
	new_projectile.init(projectile_velocity, damage, pierce, force)
	new_projectile.set_as_toplevel(true)
	new_projectile.global_position = global_position
	createdProjectiles.add_child(new_projectile)



func _get_projectile_count() -> int:
	var cached = _property_cache.get_cached("projectile_count")
	if cached:
		return cached
	var ct = projectile_count
	
	var augment_ct := 0
	for augment in _applied_augments:
		if augment is MajorAugmentFireballProjectileCount:
			augment_ct += augment.increase_in_projectile_count
	
	ct += augment_ct
	_property_cache.cache("projectile_count", ct)
	return ct


func _get_projectile_velocity() -> Vector2:
	# Send a fireball towards closest enemy
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_enemy = UTILS.get_closest_node(self, enemies)
	
	if closest_enemy:
		var dir : Vector2 = closest_enemy.global_position - self.global_position
		return dir.normalized() * _get_speed()
	return Vector2.ZERO


func _get_max_pierce() -> int:
	var pierce = max_pierce
	for augment in _applied_augments:
		if augment is MinorAugmentPierce:
			LOG.pr(1, "augment(%s, %s) is MinorAugmentPierce" % [augment, augment.pierce_increase_amount])
			pierce += augment.pierce_increase_amount
	return pierce


func _get_speed() -> float:
	var total_speed = speed
	for augment in _applied_augments:
		if augment is MinorAugmentProjectileSpeed:
			LOG.pr(1, "augment(%s, %s) is MinorAugmentProjectileSpeed" % [augment, augment.projectile_speed_increase_amount])
			total_speed += augment.projectile_speed_increase_amount
	return total_speed


### SIGNAL RESPONSES ###


func _on_CdTimer_timeout() -> void:
	_cast()
	cdTimer.start(cd)



func _on_ProjectileMaxRange_area_exited(area: Area2D) -> void:
	var entity = area.get_parent()
	if entity is Projectile:
		entity._destroy()
