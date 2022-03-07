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
export(float) var base_damage := 20.0 
export(float) var cd := 5.0 
export(int) var max_pierce := 0

### PUBLIC VAR ###



### PRIVATE VAR ###


### ONREADY VAR ###
onready var cdTimer = $CdTimer as Timer
onready var createdProjectiles = $CreatedProjectiles as Node2D


### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func start() -> void:
	cdTimer.start(cd)


### PRIVATE FUNCTIONS ###
func _cast() -> void:
	var projectile_velocity = _get_projectile_velocity()
	var new_projectile = ProjectilePrefab.instance()
	new_projectile.init(projectile_velocity, base_damage, max_pierce)
	new_projectile.set_as_toplevel(true)
	new_projectile.global_position = global_position
	createdProjectiles.add_child(new_projectile)


func _get_projectile_velocity() -> Vector2:
	return UTILS.random_unit_vec2() * speed


### SIGNAL RESPONSES ###


func _on_CdTimer_timeout() -> void:
	_cast()
	cdTimer.start(cd)
