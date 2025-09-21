@tool
extends RayCast2D

##THIS AREA IS THE WARNING_LASER
# Speed at which the laser extends when first fired, in pixels per second.
@export var castSpeed := 7000.0
# Maximum length of the laser in pixels.
@export var maxLength := 1400.0
# Distance in pixels from the origin to start drawing and firing the laser.
@export var startDistance := 40.0
# Base duration of the tween animation in seconds.
@export var growthTime := 0.1
@export var color := Color(1, 0, 0, 0.5): set = set_color

#seconds the warning laser stays active
@export var warningLaserTime := 1.0

var initialized := false

# If `true`, the laser is firing.
@export var isCasting := false

var warningLaserTween: Tween = null

@onready var line_2d: Line2D = $Line2D
@onready var lineWidth := line_2d.width


func _ready() -> void:
	line_2d.visible = false
	set_physics_process(false)
	set_color(color)
	
	var start := Vector2.RIGHT * startDistance
	line_2d.points = PackedVector2Array([start, start])

	initialized = true

func _physics_process(delta: float) -> void:
	# warning laser extension
	target_position.x = move_toward(
		target_position.x,
		maxLength,
		castSpeed * delta
	)

	var laser_end_position := target_position
	force_raycast_update()

	if is_colliding():
		laser_end_position = to_local(get_collision_point())

	line_2d.points[1] = laser_end_position

		
## WARNING_LASER
func set_is_casting(newValue: bool) -> void:
	if isCasting == newValue:
		return
	isCasting = newValue

	set_physics_process(isCasting)

	if not line_2d:
		return

	if isCasting and initialized:
		var laserStart := Vector2.RIGHT * startDistance
		line_2d.points[0] = laserStart
		line_2d.points[1] = laserStart
		appear()
	else:
		target_position = Vector2.ZERO
		disappear()


func appear() -> void:
	line_2d.visible = true
	if warningLaserTween and warningLaserTween.is_running():
		warningLaserTween.kill()
	warningLaserTween = create_tween()
	warningLaserTween.tween_property(line_2d, "width", lineWidth, growthTime * 2.0).from(0.0)


func disappear() -> void:
	if warningLaserTween and warningLaserTween.is_running():
		warningLaserTween.kill()
	warningLaserTween = create_tween()
	warningLaserTween.tween_property(line_2d, "width", 0.0, growthTime).from_current()
	warningLaserTween.tween_callback(line_2d.hide)


func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color

func startLaser() -> void:
	if not initialized:
		return
	isCasting = true
	set_physics_process(true)
	var laserStart := Vector2.RIGHT * startDistance
	line_2d.points[0] = laserStart
	line_2d.points[1] = laserStart
	appear()

func stopLaser() -> void:
	if not initialized:
		return
	isCasting = false
	set_physics_process(false)
	target_position = Vector2.ZERO
	disappear()
