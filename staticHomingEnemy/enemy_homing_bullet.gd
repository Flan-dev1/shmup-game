extends Node2D

class_name SpreadHomingBullet

var speed = 100
var playerPosition
var targetPosition
@onready var player = get_tree().get_first_node_in_group("player")
@export var lockDistance: float = 100

var locked: bool = false
var lockedDirection: Vector2

signal enemyBulletCollision

func _physics_process(delta):
	if not player:
		return
	
	playerPosition = player.position
	
	if not locked:
		var toPlayer = playerPosition - position
		if toPlayer.length() <= lockDistance:
			#lock the bullet's direction
			locked = true
			lockedDirection = (playerPosition - position).normalized()
		else:
			#still homing
			targetPosition = toPlayer.normalized()
			position += targetPosition * speed * delta
			look_at(playerPosition)
			
	else:
		#move in locked direction
		position += targetPosition * speed * delta
		rotation = lockedDirection.angle()
		
	
func _on_body_entered(body: Node2D) -> void:
	enemyBulletCollision.emit()
	
	if body is CharacterBody2D:
		queue_free()
