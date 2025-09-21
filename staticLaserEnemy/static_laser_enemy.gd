extends Area2D

var rng := RandomNumberGenerator.new()
@onready var laser = $enemyLaser

signal collision
signal spawnBullet(enemyBullet)

func _ready():
	#Spawn points
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)
	
	
func _physics_process(delta: float) -> void:
	look_at(get_global_mouse_position())
	laser.isCasting = Input.is_action_pressed("ui_click")
