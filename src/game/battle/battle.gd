extends Node2D

"""

"""

### SIGNAL ###
signal scene_loaded()

### ENUM ###


### CONST ###
const EnemyPrefab = preload("res://src/game/enemies/enemy.tscn")
const BatEyePrefab = preload("res://src/game/enemies/EnemyBatEye.tscn")

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _exp_system := ExpSystem.new(100)

### ONREADY VAR ###
onready var expDisplay = $UILayer/ExpDisplay as ExpDisplay



### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	LOG.pr(1, "BATTLE READY")
	emit_signal("scene_loaded")
	
	UTILS.bind($Env/Player, "object_created", self, "_on_object_created")
	
	# _exp_system -> expDisplay
	UTILS.bind(_exp_system, "exp_changed", expDisplay, "_on_exp_changed")
	UTILS.bind(_exp_system, "level_up", expDisplay, "_on_level_up")



### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_SpawnTimer_timeout() -> void:
	var new_enemy = BatEyePrefab.instance()
	$Env.add_child(new_enemy)
	new_enemy.global_position = Vector2(200.0, 200.0)
	new_enemy.set_target($Env/Player)
	UTILS.bind(new_enemy, "died", self, "_on_enemy_died")


func _on_object_created(obj) -> void:
	$Env.add_child(obj)



func _on_enemy_died(exp_reward) -> void:
	_exp_system.gain_exp(exp_reward)
