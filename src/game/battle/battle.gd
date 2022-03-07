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
onready var skillSelectionDialog = $UILayer/SkillSelectionDialog as SkillSelectionDialog
onready var player = $Env/Player as Player

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	LOG.pr(1, "BATTLE READY")
	emit_signal("scene_loaded")
	
	# _exp_system -> expDisplay
	UTILS.bind(_exp_system, "exp_changed", expDisplay, "_on_exp_changed")
	UTILS.bind(_exp_system, "level_up", expDisplay, "_on_level_up")
	UTILS.bind(_exp_system, "level_up", self, "_on_player_level_up")
	
	# Skill Selection Dialog
	UTILS.bind(skillSelectionDialog, "skill_selected", self, "_on_skill_selected_for_upgrade")


# warning-ignore:unused_argument
func _process(delta: float) -> void:
	pass
#	if Input.is_action_just_pressed("shoot"):
#		_pause()

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###
func _pause() -> void:
	if Engine.time_scale > 0.0:
		Engine.time_scale = 0.0
	else:
		Engine.time_scale = 1.0


### SIGNAL RESPONSES ###


func _on_SpawnTimer_timeout() -> void:
	var new_enemy = BatEyePrefab.instance()
	$Env.add_child(new_enemy)
	new_enemy.global_position = Vector2(200.0, 200.0)
	new_enemy.set_target($Env/Player)
	UTILS.bind(new_enemy, "died", self, "_on_enemy_died")



func _on_enemy_died(exp_reward) -> void:
	_exp_system.gain_exp(exp_reward)



func _on_player_level_up(_new_level) -> void:
	_pause()
	var skills = player.get_skills()
	while skills.size() < 3:
		skills.append(Arc.new())

	skillSelectionDialog.set_skills(skills)
	skillSelectionDialog.show()


# warning-ignore:unused_argument
func _on_skill_selected_for_upgrade(skill : Skill) -> void:
	_pause()
	skillSelectionDialog.hide()
