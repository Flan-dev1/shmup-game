extends CharacterBody2D

@export_subgroup("Movement Properties")
@export var speed: int = 400
@export_range (0.20,.50) var slow_modifier: float = 0.5

func get_input():
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	
	if Input.is_action_pressed('ui_shift'):  # yung slow strafe type shi ni ZUN
		velocity = input_direction * speed * slow_modifier
	else:
		velocity = input_direction * speed
	
	if Input.is_action_just_pressed('ui_shift'):
		slow_time(true)
	
	if Input.is_action_just_released('ui_shift'):
		slow_time(false)


func _physics_process(_delta):
	get_input()
	move_and_slide()

func slow_time(isSlow):
	if isSlow:
		Engine.time_scale = 0.5
	else:
		Engine.time_scale = 1
