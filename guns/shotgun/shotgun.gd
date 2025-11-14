extends Shooter

@export var bulletCount = 4 # how many bullets/pellets will come out 
@export var spread = 10

func _ready() -> void:
	super()

func _process(delta):
	super(delta)

func shoot_bullet() -> void:
	var initial_vector = -transform.y.rotated(-deg_to_rad(spread*(bulletCount-1)))
	var last_vector = -transform.y.rotated(deg_to_rad(spread*(bulletCount-1)))
	var distance = initial_vector.angle_to(last_vector)
	
	var step = 0
	if(bulletCount > 1):
		step = distance / (bulletCount-1)
	
	var forward_vector = initial_vector
	
	for i in range(bulletCount):
		var bullet = pool.pull_from_pool(bulletType) as Bullet
		
		if(!bullet.get_parent() && get_tree()):
			get_tree().root.add_child(bullet)
		
		# 2. reset position and vector
		print(rad_to_deg(forward_vector.angle()))
		bullet.initialize(global_position,forward_vector)
		
		# set up signals
		bullet.connect('request_return_to_pool',Callable(self,'_on_bullet_return_requested'))
		bullet.scheduleRemoval()
	
		# 3. Enable Bullet
		bullet.set_physics_process(true)
		bullet.set_process(true)
		bullet.show()
	
		bullet.forward_vector = forward_vector
		var sprite = bullet.sprite2D as Sprite2D
		sprite.rotation = forward_vector.angle() + Vector2.UP.angle()
		
		forward_vector = forward_vector.rotated(step)
	
