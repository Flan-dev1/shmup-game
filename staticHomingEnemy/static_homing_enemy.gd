extends Area2D

var rng := RandomNumberGenerator.new()

const bulletScene = preload("res://staticHomingEnemy/enemy_homing_bullet.tscn")
@onready var shootTimer = $shootTimer

signal collision
signal spawnBullet(enemyBullet)

func _ready():
	#Spawn points
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)
	
	shootTimer.start()


func _on_shoot_timer_timeout() -> void:
	var enemyBullet = bulletScene.instantiate()
	get_parent().add_child(enemyBullet)
	enemyBullet.global_position = global_position
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
