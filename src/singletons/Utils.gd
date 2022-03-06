extends Node
class_name Utils

const DelayedCall = preload("res://src/delayed_call.tscn")


func clamp01(value):
	return clamp(value, 0.0, 1.0)


func random_unit_vec2() -> Vector2:
	var theta = rand_range(0, 2 * PI)
	var cs = cos(theta)
	var vec = Vector2(cs, 1.0 - cs * cs)
	return vec


func create_delayed_call(caller, function, args, delay):
	if is_zero_approx(delay):
		caller.callv(function, args)
		return
	
	var new_call = DelayedCall.instance()
	new_call.init(caller, function, args, delay)
	add_child(new_call)


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
