extends Node2D

@export var pool:ObjectPool
@export var bulletsPerSecond:int

@onready var timer = $CooldownTimer

func _ready() -> void:
	timer.wait_time = 1.0/bulletsPerSecond
	#TODO: change speed slightly based on player movement or adjust speed to always have constant bullet distance

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
	
	var forward_vector = -transform.y #technically transform.x is the forward vector
	
	
	bullet.forward_vector = forward_vector
	var sprite = bullet.sprite2D as Sprite2D
	sprite.rotation = forward_vector.angle() + Vector2.UP.angle()
	
	
func _on_bullet_return_requested(bullet:Bullet):
	pool.add_to_pool(bullet)
	bullet.disconnect('request_return_to_pool',Callable(self,'_on_bullet_return_requested'))
