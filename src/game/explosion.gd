extends Node2D
class_name Explosion

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###


### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###

### ONREADY VAR ###
onready var hitBox = $HitBox
onready var effect = $ExplosionEffect

### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func init(area_radius : float, hit_mask) -> void:
	scale *= area_radius / 50.0
	hitBox.collision_mask = hit_mask


func hit(damage : float) -> void:
	effect.start(scale.x)
	yield(get_tree().create_timer(0.1), "timeout")

	var overlap = hitBox.get_overlapping_areas()
	for area in overlap:
		var entity = area.get_parent()
		entity.take_damage(damage)

	queue_free()


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
