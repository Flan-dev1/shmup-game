extends Node

class_name ObjectPool

var object_pool: Array = []

func add_to_pool(object: Bullet) -> void:
	object_pool.append(object)
	
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()

func pull_from_pool(bullet : PackedScene) -> Node2D:
	var object: Node2D
	
	if object_pool.is_empty():
		object = bullet.instantiate()
	else:
		var object_index = object_pool.find_custom(
			func(stored):
				return stored.get_class() == bullet.get_class()
		)
		
		if(object_index != -1):
			object = object_pool[object_index]
			object_pool.remove_at(object_index)
		else:
			object = bullet.instantiate()
	
	return object
