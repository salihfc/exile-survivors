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


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var createdProjectiles = $CreatedProjectiles as Node2D


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###



### PRIVATE FUNCTIONS ###
func _cast() -> void:
	var projectile_velocity = _get_projectile_velocity()
	var new_projectile = ProjectilePrefab.instance()
	new_projectile.init(projectile_velocity, _get_damage(), _get_max_pierce())
	new_projectile.set_as_toplevel(true)
	new_projectile.global_position = global_position
	createdProjectiles.add_child(new_projectile)


func _get_projectile_velocity() -> Vector2:
	# Send a fireball towards closest enemy
	var enemies = get_tree().get_nodes_in_group("enemy")
	var closest_enemy = UTILS.get_closest_node(self, enemies)
	var dir : Vector2 = closest_enemy.global_position - self.global_position
	return dir.normalized() * _get_speed()




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
