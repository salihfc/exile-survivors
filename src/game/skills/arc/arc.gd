extends Skill
class_name Arc

"""

"""

### SIGNAL ###


### ENUM ###


### CONST ###
const FadingLinePrefab = preload("res://src/game/effects/fading_line.tscn")

### EXPORT ###
export(float) var chain_range := 400.0
export(float) var max_chain := 5.0

### PUBLIC VAR ###


### PRIVATE VAR ###


### ONREADY VAR ###
onready var area = $RangeArea as Area2D
onready var lineContainer = $VisualLines as Node2D

### VIRTUAL FUNCTIONS (_init ...) ###
func _ready() -> void:
	pass
	lineContainer.set_as_toplevel(true)


### PUBLIC FUNCTIONS ###


### PRIVATE FUNCTIONS ###
func _get_max_chain() -> int:
	var chain = max_chain
	for augment in _applied_augments:
		if augment is MinorAugmentChain:
#			LOG.pr(1, "augment(%s) is MinorAugmentChain" % [augment])
			chain += augment.chain_increase_amount
	return chain


func _get_chain_range() -> float:
	var _range = chain_range
	for augment in _applied_augments:
		if augment is MinorAugmentChainRange:
#			LOG.pr(1, "augment(%s) is MinorAugmentChain" % [augment])
			_range += augment.chain_range_increase
	return _range


func _cast_starting_from(closest):
	var all_enemies = get_tree().get_nodes_in_group("enemy")
	var mst_solver = (UTILS as Utils).MST_solver.new(closest, all_enemies)
	var edges = mst_solver.get_mst_edges_with(_get_max_chain(), _get_chain_range())
#	LOG.pr(1, "ARC CASTED WITH LINES: (%s) -> (%s)" % [all_enemies.size(), edges.size()])

	edges.push_front([self, closest, 0])
	
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
		(UTILS as Utils).create_delayed_call(end, "take_damage", [arc_damage], delay)
		LOG.pr(1, "(%s) should be hit in (%s) secs with (%s)" % [end, delay, arc_damage])


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
	LOG.pr(1, "TRY CASTING ARC")
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
