extends Node2D

class_name SpreadEnemyBullet

var speed = 100

signal enemyBulletCollision

func _process(delta: float) -> void:
	position += transform.x * speed * delta

func _on_kill_timer_timeout() -> void:
	queue_free()

func _on_body_entered(body) -> void:
	enemyBulletCollision.emit()
	
	if body is CharacterBody2D:
		queue_free()
