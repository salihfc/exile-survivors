extends Node2D

"""

"""

### SIGNAL ###
signal scene_loaded()

### ENUM ###


### CONST ###
const EnemyPrefab = preload("res://src/game/enemies/enemy.tscn")

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	LOG.pr(1, "BATTLE READY")
	emit_signal("scene_loaded")
	var err = $Env/Player.connect("object_created", self, "_on_object_created")
	if err != OK:
		push_error("Cannot connect signal (%s)" % [err])

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###


func _on_SpawnTimer_timeout() -> void:
	var new_enemy = EnemyPrefab.instance()
	$Env.add_child(new_enemy)
	new_enemy.global_position = Vector2(200.0, 200.0)
	new_enemy.set_target($Env/Player)


func _on_object_created(obj) -> void:
	$Env.add_child(obj)
