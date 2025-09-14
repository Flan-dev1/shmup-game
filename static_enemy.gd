extends Area2D

var rng := RandomNumberGenerator.new()

#Bullet spawn
const bulletScene = preload("res://enemy_bullet.tscn")
@onready var shootTimer = $shootTimer
@onready var rotater = $rotater

@export_category("Bullet Behavior")
@export var rotateSpeed= 100
@export var shootTimerWaitTime = 0.2
@export var spawnPointCount = 4
@export var radius = 100

signal collision
signal spawnBullet(enemyBullet)

func _ready():
	#Spawn points
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)
	
	
	#Enemy Bullets
	var step = 2 * PI / spawnPointCount
	
	for i in range(spawnPointCount):
		var spawnPoint = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawnPoint.position = pos
		spawnPoint.rotation = pos.angle()
		rotater.add_child(spawnPoint)
		
	shootTimer.wait_time = shootTimerWaitTime
	shootTimer.start()
	
func _process(delta):
	#change rotation_degrees to "- rotateSpeed" to make it counter clockwise
	var newRotation = rotater.rotation_degrees + rotateSpeed * delta
	rotater.rotation_degrees = fmod(newRotation, 360)

func _on_shoot_timer_timeout() -> void:
	for s in rotater.get_children():
		var enemyBullet = bulletScene.instantiate()
		get_tree().root.add_child(enemyBullet)
		enemyBullet.position = s.global_position
		enemyBullet.rotation = s.global_rotation	
		emit_signal("spawnBullet",enemyBullet)

func _on_area_entered(area: Area2D) -> void:
	if area is Bullet and area_entered.is_connected(_on_area_entered):
		area_entered.disconnect(_on_area_entered)
		# add 1 point to the score
		ScoreManager.add_score(1)
		
		area = area as Bullet
		area.die()
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	collision.emit()
	
	if body is CharacterBody2D:
		queue_free()
