extends Area2D

class_name Bullet

@export var despawn_timer:float = 0.25
@export var speed = 400

@onready var sprite2D = $Sprite2D
var forward_vector

signal request_return_to_pool

func _ready():
	scheduleRemoval()

func _process(delta):
	global_position += forward_vector * speed * delta


func scheduleRemoval():
	await get_tree().create_timer(despawn_timer).timeout
	sendRemovalSignal()
	
func sendRemovalSignal():
	emit_signal("request_return_to_pool", self)
