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


func create_delayed_call(caller, function, args, delay):
	if is_zero_approx(delay):
		caller.callv(function, args)
		return
	
	var new_call = DelayedCall.instance()
	new_call.init(caller, function, args, delay)
	add_child(new_call)


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
