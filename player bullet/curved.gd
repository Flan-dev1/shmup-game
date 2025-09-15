extends Bullet

class_name Curved

var base_position
var time_passed

@export_category("Curvature")
@export var amplitude = 20.0
@export var frequency = 5

func initialize(startingPosition : Vector2, startingVector: Vector2):
	base_position = startingPosition
	forward_vector = startingVector
	time_passed = 0.0

func _process(delta):
	time_passed += delta
	base_position += forward_vector * speed * delta
			
	var perp = Vector2(-forward_vector.y, forward_vector.x)
	var offset = perp * amplitude * sin(time_passed * frequency * TAU)
				
	global_position = base_position + offset
