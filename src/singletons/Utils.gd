extends Node
class_name Utils

const DelayedCall = preload("res://src/delayed_call.tscn")

func bind(
		source_node : Object, signal_name : String,
		target_node : Object, method_name : String,
		binds := []) -> void:

	var err = source_node.connect(signal_name, target_node, method_name, binds)
	if err != OK:
		push_error("CANNOT BIND SIGNAL")


func eval(expression_string, param_names, param_values):
	var expression = Expression.new()
	expression.parse(expression_string, param_names)
	var result = expression.execute(param_values)
	if result:
		return result
	return -1


func interpolate_method_to_and_back(
		tween : Tween,
		object : Object, method : String,
		start_value, mid_value,
		part1_duration, part2_duration) -> void:
	
# warning-ignore:return_value_discarded
	tween.interpolate_method(
			object, method,
			start_value, mid_value,
			part1_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT
	)

# warning-ignore:return_value_discarded
	tween.interpolate_method(
			object, method,
			mid_value, start_value,
			part2_duration, Tween.TRANS_QUART, Tween.EASE_IN_OUT,
			part1_duration
	)

# warning-ignore:return_value_discarded
	tween.start()


func clamp01(value):
	return clamp(value, 0.0, 1.0)


func test_random_unit_vec2() -> void:
	var q = 1000000
	var quad_freq = [0, 0, 0, 0, 0, 0]
	
	for _i in q:
		var unit = random_unit_vec2()
		var quadrant = 5
		if sign(unit.y) > 0: # Upper half
			quadrant = 1 + int(unit.x < 0)
		else:
			quadrant = 4 - int(unit.x < 0)
		
		quad_freq[quadrant] += 1
	print (quad_freq)
	get_tree().quit()


func random_unit_vec2() -> Vector2:
	var theta = rand_range(0, 2 * PI)
	return Vector2(cos(theta), sin(theta))


func check(p : float) -> bool:
	return randf() <= p


func get_random_subset(set : Array, ct : int) -> Array:
	set.shuffle()
	return set.slice(0, ct - 1)


func create_delayed_call(caller, function, args, delay):
	if is_zero_approx(delay):
		caller.callv(function, args)
		return
	
	var new_call = DelayedCall.instance()
	new_call.init(caller, function, args, delay)
	add_child(new_call)


func get_closest_node(node : Node2D, other_nodes : Array):
	if node in other_nodes:
		other_nodes.erase(node)
	
	var closest = null
	var min_dist = INF
	
	for other_node in other_nodes:
		var dist = node.global_position.distance_to(other_node.global_position)
		if dist < min_dist:
			min_dist = dist
			closest = other_node

	return closest


### CHAIN CLASS ###
class Chain_solver:
	var _starting_entity = null
	var _entities = []
	
	func _init(starting_entity, remaning_entities) -> void:
		_starting_entity = starting_entity
		_entities = remaning_entities
		
		if _starting_entity in _entities:
			_entities.erase(_starting_entity)

	func get_chain(chain_count, chain_range) -> Array:
		var edges = []
		var current = _starting_entity
		var entity_depth = {
			_starting_entity : 0,
		}
		
		for _i in range(chain_count):
			var min_dist = INF
			var closest = null
			
			for entity in _entities:
				var dist = entity.global_position.distance_to(current.global_position)
				if min_dist > dist:
					min_dist = dist
					closest = entity
			
			if closest == null or min_dist > chain_range:
				break
			
			entity_depth[closest] = entity_depth[current] + 1
			_entities.erase(closest)
			edges.append([current, closest, entity_depth[closest]])
			current = closest
		
		return edges

### CHAIN CLASS END ###

### MST FUNCTIONS ###
class MST_solver:
	
	var _starting_entity = null
	var _entities = []
	
	func _init(starting_entity, remaning_entities) -> void:
		_starting_entity = starting_entity
		_entities = remaning_entities
		
		if _starting_entity in _entities:
			_entities.erase(_starting_entity)
	
	
	func get_mst_edges_with(chain_count, chain_range) -> Array:
		var edges = []
		var selected_set = [_starting_entity]
		var entity_depth = {
			_starting_entity : 0,
		}
		
		for _i in range(chain_count):
			var min_dist = INF
			var closest = null
			var origin = null
			
			for set_entity in selected_set:
				for entity in _entities:
					var dist = entity.global_position.distance_to(set_entity.global_position)
					if min_dist > dist:
						min_dist = dist
						closest = entity
						origin = set_entity
			
#			LOG.pr(1, "(_i: %s), (min_dist: %s), (closest: %s), (origin: %s)" % [_i, min_dist, closest, origin])
			if closest == null or min_dist > chain_range:
				break
			
			entity_depth[closest] = entity_depth[origin] + 1
			selected_set.append(closest)
			_entities.erase(closest)
			edges.append([origin, closest, entity_depth[closest]])
		
		return edges
### MST FUNCTIONS ### END
