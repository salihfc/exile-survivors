extends Node2D

"""

"""

### SIGNAL ###
signal scene_loaded()

### ENUM ###


### CONST ###
# Enemy
const EnemyPrefab = preload("res://src/game/enemies/enemy.tscn")
const BatEyePrefab = preload("res://src/game/enemies/EnemyBatEye.tscn")

const FloatingTextPrefab = preload("res://src/game/effects/floating_text.tscn")
### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
var _last_selected_skill_for_augmentation : Skill
var _exp_system := ExpSystem.new(100)

### ONREADY VAR ###
# UI
onready var expDisplay = $UILayer/ExpDisplay as ExpDisplay
onready var skillSelectionDialog = $UILayer/SkillSelectionDialog as SkillSelectionDialog
onready var augmentSelectionDialog = $UILayer/AugmentSelectionDialog as AugmentSelectionDialog

# Game
onready var floatingTextContainer = $FloatingTextContainer as Node2D

onready var enemySpawnPos = $EnemySpawnPositions as Node2D
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

	# Augment Selection Dialog
	UTILS.bind(augmentSelectionDialog, "augment_selected", self, "_on_augment_selected_for_skill")

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	pass
	if Input.is_action_just_pressed("pause"):
		_pause()

### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###
func _pause() -> void:
	if Engine.time_scale > 0.0:
		Engine.time_scale = 0.0
	else:
		Engine.time_scale = 1.0


func _get_random_spawn_pos() -> Vector2:
	var R = 200.0

	var all_pos = enemySpawnPos.get_children()
	var pos = all_pos[(randi() % all_pos.size())].global_position
	var rand_vec = UTILS.random_unit_vec2()
	var rand_rad = rand_range(0.0, R)
	var spawn = pos + rand_vec * rand_rad

	return spawn


### SIGNAL RESPONSES ###


func _on_SpawnTimer_timeout() -> void:
	var new_enemy = BatEyePrefab.instance()
	$Env.add_child(new_enemy)
	new_enemy.global_position = _get_random_spawn_pos()
	new_enemy.set_target($Env/Player)
	new_enemy.set_scaled_hp(_exp_system.get_level()) 
	UTILS.bind(new_enemy, "died", self, "_on_enemy_died")
	UTILS.bind(new_enemy, "damage_taken", self, "_on_enemy_damage_taken")



func _on_enemy_died(exp_reward) -> void:
	_exp_system.gain_exp(exp_reward)


func _on_enemy_damage_taken(pos, amount) -> void:
	if CONFIG.SHOW_DAMAGE_NUMBERS:
		var random_vel = UTILS.random_unit_vec2() * rand_range(40.0, 100.0)
		random_vel.y = -abs(random_vel.y)

		var floating_text = FloatingTextPrefab.instance()
		floating_text.init(str(amount), pos + Vector2.UP * 100.0, random_vel, 0.5)
		floatingTextContainer.add_child(floating_text)


func _on_player_level_up(_new_level) -> void:
	_pause()
	var skills = player.get_skills()
	LOG.pr(1, "player skills (%s)" % [skills])
	while skills.size() < 3:
		var new_skill = Arc.new()
		skills.append(new_skill)

	skillSelectionDialog.show()
	skillSelectionDialog.set_skills(skills)


# warning-ignore:unused_argument
func _on_skill_selected_for_upgrade(skill : Skill) -> void:
	LOG.pr(1, "Skill selected for upgrade (%s)" % [skill])
	skillSelectionDialog.hide()
	_last_selected_skill_for_augmentation = skill
	
# warning-ignore:unsafe_property_access
	var augments = skill.get_possible_augments()
#	LOG.pr(1, "player skills (%s)" % [skills])
	while augments.size() < 3:
		var aug = Augment.new()
		augments.append(aug)

	if augments.size() > 3:
		augments = UTILS.get_random_subset(augments, 3)

	augmentSelectionDialog.show()
	augmentSelectionDialog.set_augments(augments)


func _on_augment_selected_for_skill(augment : Augment) -> void:
	augmentSelectionDialog.hide()
	LOG.pr(1, "Apply augment(%s) to skill(%s)" % [augment, _last_selected_skill_for_augmentation])
	_last_selected_skill_for_augmentation.apply_augment(augment)

	# Unpausing
	_pause()
