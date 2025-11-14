extends Node

class_name ObjectPool

var object_pool: Dictionary = {}
var instantiated = 0

func add_to_pool(object: Bullet) -> void:
	var bullet_array = object_pool.find_key(object.get_class())
	
	(object_pool.get_or_add(object.get_script().get_global_name(),[]) as Array).append(object)
	
	object.set_process(false)
	object.set_physics_process(false)
	object.hide()

func pull_from_pool(bullet : PackedScene) -> Node2D:
	var object: Node2D
	
	if object_pool.is_empty():
		object = bullet.instantiate()
	else:
		var bullet_class = bullet.instantiate().get_script().get_global_name()
		if((object_pool.get_or_add(bullet_class,[]) as Array).size()!=0):
			return (object_pool.get_or_add(bullet_class,[]) as Array).pop_back()
		else:
			object = bullet.instantiate()
	
	return object
