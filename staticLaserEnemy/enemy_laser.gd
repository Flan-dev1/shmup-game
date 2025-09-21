@tool
extends RayCast2D

##THIS AREA IS THE MAIN LASER
# Speed at which the laser extends when first fired, in pixels per second.
@export var castSpeed := 7000.0
# Maximum length of the laser in pixels.
@export var maxLength := 1400.0
# Distance in pixels from the origin to start drawing and firing the laser.
@export var startDistance := 40.0
# Base duration of the tween animation in seconds.
@export var growthTime := 0.1
@export var color := Color.WHITE: set = set_color

#seconds the white laser stays active
@export var mainLaserTime := 1.0

# If `true`, the laser is firing.
@export var isCasting := false: set = set_is_casting

## THIS AREA IS FOR THE WARNINGLINE LASER
#seconds before the laser fires
@export var warningTime := 1.0 
#seconds it takes for the warning line to extend
@export var warningGrowthTime := 1.0 

@export var warningColor: Color = Color(1, 0, 0, 0.5) #red at 50% transparency

var tween: Tween = null

@onready var line_2d: Line2D = $Line2D
@onready var warningLine: Line2D = $warningLine
@onready var lineWidth := line_2d.width



func _ready() -> void:
	set_color(color)
	set_is_casting(isCasting)
	
	var start := Vector2.RIGHT * startDistance
	line_2d.points = PackedVector2Array([start, start])
	line_2d.visible = false

	warningLine.points = PackedVector2Array([start, start])
	warningLine.visible = false
	
	if not Engine.is_editor_hint():
		set_physics_process(false)


func _physics_process(delta: float) -> void:
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

## MAIN LASER
func set_is_casting(newValue: bool) -> void:
	if isCasting == newValue:
		return
	isCasting = newValue

	set_physics_process(isCasting)

	if not line_2d:
		return

	if isCasting:
		var laserStart := Vector2.RIGHT * startDistance
		line_2d.points[0] = laserStart
		line_2d.points[1] = laserStart
		appear()
	else:
		target_position = Vector2.ZERO
		disappear()


func appear() -> void:
	line_2d.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", lineWidth, growthTime * 2.0).from(0.0)


func disappear() -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.tween_property(line_2d, "width", 0.0, growthTime).from_current()
	tween.tween_callback(line_2d.hide)


func set_color(new_color: Color) -> void:
	color = new_color
	if line_2d == null:
		return
	line_2d.modulate = new_color


## WARNINGLASER
func prepareLaser():
	#reset line positions
	var start := Vector2.RIGHT * startDistance
	var end := Vector2.RIGHT * maxLength
	
	#reset warning line completely
	warningLine.visible = false
	warningLine.points = PackedVector2Array([start, start])
	warningLine.width = lineWidth / 2
	warningLine.modulate = warningColor
	
	#kill left over tween
	if tween and tween.is_running():
		tween.kill()
	
	#animate the end point gradually
	tween = create_tween()
	warningLine.visible = true
	tween.tween_method(set_warning_end, start, end, warningGrowthTime)

func set_warning_end(p: Vector2) -> void:
	warningLine.set_point_position(1, p)

func fire_laser():
	warningLine.visible = false
	set_is_casting(true)
	
	await get_tree().create_timer(mainLaserTime).timeout
	set_is_casting(false)
