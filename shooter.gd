extends Node2D

@export var pool:ObjectPool

func _process(_delta: float) -> void:
	#shoot_bullet()
	return

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_space"):
		print('spacebar')
		shoot_bullet()

func shoot_bullet() -> void:
	# 1. Get From Pool/Instantiate
	var bullet = pool.pull_from_pool() as Bullet
	
	if(!bullet.get_parent() && get_tree()):
		get_tree().root.add_child(bullet)
	
	# 2. reset position and vector?
	bullet.global_position = global_position
	
	# I forgot about this step, basically set up signals
	bullet.connect('request_return_to_pool',Callable(self,'_on_bullet_return_requested'))
	
	# 3. Enable Bullet
	bullet.set_physics_process(true)
	bullet.set_process(true)
	bullet.show()
	
	var forward_vector = -transform.y #technically transform.x is the forward vector
	
	bullet.forward_vector = forward_vector
	
	
func _on_bullet_return_requested(bullet:Bullet):
	print('signal received')
	pool.add_to_pool(bullet)
	bullet.disconnect('request_return_to_pool',Callable(self,'_on_bullet_return_requested'))
