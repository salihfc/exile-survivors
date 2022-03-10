extends Skill
class_name Arc

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const FadingLinePrefab = preload("res://src/game/effects/fading_line.tscn")
const ExplosionPrefab = preload("res://src/game/explosion.tscn")

### EXPORT ###
export(String) var area_damage_expression
export(String) var area_radius_expression

export(float) var chain_range := 400.0
export(float) var max_chain := 5.0

### PUBLIC VAR ###


### PRIVATE VAR ###
var _radius = 6.0
var _area_damage = 40.0


### ONREADY VAR ###
onready var area = $RangeArea as Area2D
onready var lineContainer = $VisualLines as Node2D
onready var explosionContainer = $Explosions as Node2D


### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	lineContainer.set_as_toplevel(true)
	explosionContainer.set_as_toplevel(true)

# warning-ignore:unused_argument
func _process(delta: float) -> void:
	
	if Input.is_action_just_pressed("debug_e"):
		var aug = MajorAugmentArcEndOfChainExplosion.new()
		apply_augment(aug)


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###
func _get_augment_count() -> int:
	var cached_value = _property_cache.get_cached("behaviour_chain_and_explosion_ct")
	if cached_value:
		return cached_value

	var augment_ct := 0
	for augment in _applied_augments:
		if augment is MajorAugmentArcEndOfChainExplosion:
			augment_ct += 1
	_property_cache.cache("behaviour_chain_and_explosion_ct", augment_ct)
	
	LOG.pr(1, "Augment CT: (%s)" % [augment_ct])
	return augment_ct


func _get_explosion_area_damage() -> float:
	var cached_value = _property_cache.get_cached("area_damage")
	if cached_value:
		return cached_value
	var augment_ct := _get_augment_count()
	var extra = UTILS.eval(area_damage_expression, ["x"], [augment_ct])
	var calculated = _area_damage * sqrt(extra)
	_property_cache.cache("area_damage", calculated)
	return _property_cache.get_cached("area_damage")


func _get_explosion_area_radius() -> float:
	var cached_value = _property_cache.get_cached("area_radius")
	if cached_value:
		return cached_value
	var augment_ct := _get_augment_count()
	var extra = UTILS.eval(area_radius_expression, ["x"], [augment_ct])
	var calculated = _radius * (_get_radius_scaling(extra))
	_property_cache.cache("area_radius", calculated)
	return _property_cache.get_cached("area_radius")


func _get_radius_scaling(x) -> float:
	return x + 4.0
#	return pow(x, 0.90) / 2.0 + 4.0


func _is_changed_to_chain():
	var cached_value = _property_cache.get_cached("behaviour_chain_and_explosion")
	if cached_value:
		return cached_value
	
	var chain = false
	for augment in _applied_augments:
		if augment is MajorAugmentArcEndOfChainExplosion:
			chain = true
			break
	_property_cache.cache("behaviour_chain_and_explosion", chain)
	return chain


func _get_max_chain() -> int:
	var cached_value = _property_cache.get_cached("max_chain")
	if cached_value:
		return cached_value
	
	var chain = max_chain
	for augment in _applied_augments:
		if augment is MinorAugmentChain:
			chain += augment.chain_increase_amount
	
	_property_cache.cache("max_chain", chain)
	return chain


func _get_chain_range() -> float:
	var cached_value = _property_cache.get_cached("chain_range")
	if cached_value:
		return cached_value
	
	var _range = chain_range
	for augment in _applied_augments:
		if augment is MinorAugmentChainRange:
#			LOG.pr(1, "augment(%s) is MinorAugmentChain" % [augment])
			_range += augment.chain_range_increase
	_property_cache.cache("chain_range", _range)
	return _range


func _get_edges(closest) -> Array:
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var mst_solver = (UTILS as Utils).MST_solver.new(closest, all_enemies)
	var edges = mst_solver.get_mst_edges_with(_get_max_chain(), _get_chain_range())
	return edges


func _get_chain(closest) -> Array:
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var chain_solver = (UTILS as Utils).Chain_solver.new(closest, all_enemies)
	var edges = chain_solver.get_chain(_get_max_chain(), _get_chain_range())
	return edges


func _cast_starting_from(closest):
	var edges
	
	if _is_changed_to_chain():
		edges = _get_chain(closest)
	else:
		edges = _get_edges(closest)
	
	edges.push_front([self, closest, 0])

#	LOG.pr(1, "ARC CASTED WITH LINES: (%s) -> (%s)" % [all_enemies.size(), edges.size()])
	
	var appearing_time = 0.02
	var disappering_time = 0.03
#	var single_line_completion_time = appearing_time
	var single_line_completion_time = 0.0
	# Create Lines from edges
	var arc_damage = _get_damage()
	for edge in edges:
		var start = edge[0]
		var end = edge[1]
		var depth = edge[2]
		var delay = depth * single_line_completion_time
		
		var fading_line = FadingLinePrefab.instance()
		fading_line.init(
				start.global_position, end.global_position, 
				disappering_time, appearing_time,
				delay
		)
		
		lineContainer.add_child(fading_line)
		if UTILS.check(user.get_chance_to_freeze()):
			(UTILS as Utils).create_delayed_call(end, "_on_freeze_for", [1.0], delay)

		(UTILS as Utils).create_delayed_call(end, "take_damage", [arc_damage], delay)
		LOG.pr(1, "(%s) should be hit in (%s) secs with (%s)" % [end, delay, arc_damage])

		if _is_changed_to_chain() and edge == edges.back(): # explosion on Last edge if behaviour set
			var explosion_position = end.global_position
			var new_explosion = ExplosionPrefab.instance()
			explosionContainer.add_child(new_explosion)
			var explosion_radius = _get_explosion_area_radius()
			var explosion_damage = _get_explosion_area_damage()
			
			LOG.pr(1, "Explosion(%s) with r:%s, d:%s" % [new_explosion, explosion_radius, explosion_damage])
			
			new_explosion.init(explosion_radius, area.collision_mask)
			new_explosion.global_position = explosion_position
			new_explosion.hit(explosion_damage)


func _get_entities_in_range() -> Array:
	var overlap = area.get_overlapping_areas()
	var entities = []
	
	for entity_area in overlap:
		var entity = entity_area.get_parent()
		if entity:
			entities.append(entity)
	return entities

### SIGNAL RESPONSES ###


func _on_CdTimer_timeout() -> void:
#	LOG.pr(1, "TRY CASTING ARC")
	var entities = _get_entities_in_range()
	var closest = null
	var dist := INF
	
	for entity in entities:
		var distance_to_entity = global_position.distance_to(entity.global_position)
		if dist > distance_to_entity:
			dist = distance_to_entity
			closest = entity

	if closest:
		_cast_starting_from(closest)
	
	# Go on cd
	cdTimer.start(cd)
