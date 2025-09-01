extends Node

class_name ObjectPool

@export var scene: PackedScene

var object_pool: Array = []

func add_to_pool(object: Bullet) -> void:
	object_pool.append(object)
	
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()

func pull_from_pool() -> Node2D:
	var object: Node2D
	
	if object_pool.is_empty():
		object = scene.instantiate()
	else:
		object = object_pool[0]
		object_pool.remove_at(0)
	
	return object
