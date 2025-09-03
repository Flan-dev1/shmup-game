extends Area2D

class_name Enemy

@export var speed = 100
var playerPosition
var targetPosition
@onready var player = get_parent().get_parent().get_node("Player")

var rng := RandomNumberGenerator.new()

signal collision

#Tracks and Follows player
func _physics_process(delta):
	
	playerPosition = player.position
	targetPosition = (playerPosition - position).normalized()
	
	if position.distance_to(playerPosition) > 3:
		position += targetPosition * speed * delta
		
		#turns the enemy to face the player independently
		look_at(playerPosition)

func _ready():
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)

func _on_body_entered(body):
	collision.emit()
	
	if body is CharacterBody2D:
		queue_free()

func _on_area_entered(area):
	if area is Bullet and area_entered.is_connected(_on_area_entered):
		area_entered.disconnect(_on_area_entered)
		# add 1 point to the score
		ScoreManager.add_score(1)
		
		area = area as Bullet
		area.die()
		queue_free()
