extends Area2D

class_name Bullet

@export var speed = 400

@onready var sprite2D = $Sprite2D
var forward_vector
var timer: Timer 

signal request_return_to_pool

func _ready() -> void:
	timer = $DeathTimer

func _process(delta):
	global_position += forward_vector * speed * delta

func scheduleRemoval():
	timer.start()
	
func sendRemovalSignal():
	emit_signal("request_return_to_pool", self)

func die(): #placehold function for collision
	timer.stop()
	sendRemovalSignal()
