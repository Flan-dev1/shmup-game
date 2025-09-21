extends Area2D

#total time for one cycle (warning + main laser)
@export var shootInterval := 3.0 
#percent of interval for warning line e.g 60%
@export var warningRatio := 0.6
#percent of interval for main laser e.g 40%
@export var mainLaserRatio := 0.4
#cooldowntime between shots
@export var cooldownTime = 1.0

var rng := RandomNumberGenerator.new()


@onready var laser = $enemyLaser
@onready var shootTimer: Timer = $shootTimer

signal collision
signal spawnBullet(enemyBullet)


func _ready():
	#Spawn points
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)
	
	#start cycle
	start_shoot_cycle()
	
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	
func start_shoot_cycle() -> void:
	run_cycle()
	
func run_cycle() -> void:
	var warningTime = shootInterval * warningRatio
	var mainlaserTime = shootInterval * mainLaserRatio
	
	await laser.prepareLaser()
	await get_tree().create_timer(warningTime).timeout
		
	await laser.fire_laser()
	await get_tree().create_timer(mainlaserTime).timeout
		
	await laser.set_is_casting(false)
	
	#cooldown before restarting the next cycle
	await get_tree().create_timer(cooldownTime).timeout
		
	#restart after full cycle
	await get_tree().create_timer(0.01).timeout
	start_shoot_cycle()
