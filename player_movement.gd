extends CharacterBody2D

@export_subgroup("Movement Properties")
@export var speed: int = 400
@export_range (0.20,.50) var slow_modifier: float = 0.5

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if Input.is_key_pressed(KEY_SHIFT):  # yung slow strafe type shi ni ZUN
		velocity = input_direction * speed * slow_modifier
	else:
		velocity = input_direction * speed

func _physics_process(_delta):
	get_input()
	move_and_slide()
