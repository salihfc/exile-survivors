extends Resource
class_name Stats

"""
	An interface for all units to maintain and track theirs and others stats
"""

### SIGNAL ###


### ENUM ###
enum {
	HP,
	MAX_HP,
	
	DEF,
	
	RES_PHYSICAL,
	RES_FIRE,
	RES_COLD,
	RES_LIGHTNING,
	RES_DARK,
	RES_LIGHT,
	
	CRIT_RATE,
	CRIT_DAMAGE,
	DAMAGE_MULTI,
	
	STAT_COUNT,
}

### CONST ###
const STAT_NAMES = {
	HP : "_hp",
	MAX_HP : "_max_hp",
	
	DEF : "def",
	
	RES_PHYSICAL : "_res_pyhsical",
	RES_FIRE : "_res_fire",
	RES_COLD : "_res_cold",
	RES_LIGHTNING : "_res_lightning",
	RES_DARK : "_res_dark",
	RES_LIGHT : "_res_light",
	
	CRIT_RATE : "_crit_rate",
	CRIT_DAMAGE : "_crit_damage",
	DAMAGE_MULTI : "_damage_multi",
}

### EXPORT ###


### PUBLIC VAR ###


### PRIVATE VAR ###
# HP
# warning-ignore:unused_class_variable
export(float) var _max_hp = 1.0
# warning-ignore:unused_class_variable
export(float) var _hp : float = 1.0

# DEF
# warning-ignore:unused_class_variable
export(float) var _def : float = 0.0

# RESISTS
# warning-ignore:unused_class_variable
export(float) var _res_physical : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _res_fire : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _res_cold : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _res_lightning : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _res_dark : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _res_light : float = 0.0

# DAMAGE
# warning-ignore:unused_class_variable
export(float) var _crit_rate : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _crit_damage : float = 0.0
# warning-ignore:unused_class_variable
export(float) var _damage_multi : float = 1.0

### ONREADY VAR ###




### VIRTUAL FUNCTIONS (_init ...) ###


### PUBLIC FUNCTIONS ###
func init_from(other_stats):
	for i in STAT_COUNT:
		var value = other_stats.get_stat(i)
		set_stat(i, value)


func get_stat(stat_id : int):
	return get(STAT_NAMES[stat_id])


func set_stat(stat_id : int, new_value):
	set(STAT_NAMES[stat_id], new_value)


func add_to_stat(stat_id : int, add_value):
	var new_value = get_stat(stat_id) + add_value
	set_stat(stat_id, new_value)


func get_hp_perc():
	return get_stat(HP) / get_stat(MAX_HP)

### PRIVATE FUNCTIONS ###


### SIGNAL RESPONSES ###
