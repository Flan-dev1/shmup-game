extends Area2D

@export var warningTime := 3.0
@export var mainLaserTIme := 3.0
@export var cooldownTime = 1.0
@export var lockOnTime := 1.5
@export var trackingTime := 3.0

var playerPosition
var targetPosition
var rng := RandomNumberGenerator.new()

@onready var enemyLaser = $enemyLaser
@onready var warningLaser = $enemyWarningLine
@onready var player = get_tree().get_first_node_in_group("player")

enum laserState {TRACKING, LOCKON, MAIN, IDLE}
var currentState := laserState.TRACKING
var stateTimer := 0.0
var lockedRotation := 0.0

signal collision

func _ready():
	#Spawn points
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)
	
	warningLaser.isCasting = false
	enemyLaser.isCasting = false
	$enemyStartup.start()
	
func _physics_process(delta: float) -> void:
	var playerPosition = player.position
	
	if currentState == laserState.TRACKING:
		look_at(playerPosition)
	
	#countdown
	stateTimer -= delta
	if stateTimer <= 0.0:
		match currentState:
			laserState.TRACKING:
				set_laser_state(laserState.LOCKON)
			laserState.LOCKON:
				set_laser_state(laserState.MAIN)
			laserState.MAIN:
				set_laser_state(laserState.IDLE)
			laserState.IDLE:
				set_laser_state(laserState.TRACKING)
	
#Center state machine
func set_laser_state(newState: int) -> void:
	if currentState == newState:
		return
	
	currentState = newState
	
	match newState:
		laserState.TRACKING:
			#warning laser is on while tracking
			warningLaser.startLaser()
			enemyLaser.stopLaser()
			stateTimer = trackingTime
		laserState.LOCKON:
			#store current rotation before freezing
			lockedRotation = rotation
			#freeze rotation
			rotation = lockedRotation
			warningLaser.startLaser()
			enemyLaser.stopLaser()
			stateTimer = lockOnTime
		laserState.MAIN:
			#keep locked rotation
			rotation = lockedRotation
			warningLaser.stopLaser()
			enemyLaser.startLaser()
			stateTimer = mainLaserTIme
		laserState.IDLE:
			#hide both laser
			warningLaser.stopLaser()
			enemyLaser.stopLaser()
			stateTimer = cooldownTime
			


func _on_body_entered(body: Node2D) -> void:
	collision.emit()
	
	if body is CharacterBody2D:
		queue_free()


func _on_area_entered(area: Area2D) -> void:
	if area is Bullet and area_entered.is_connected(_on_area_entered):
		area_entered.disconnect(_on_area_entered)
		# add 1 point to the score
		ScoreManager.add_score(1)
		
		area = area as Bullet
		area.die()
		queue_free()


func _on_enemy_startup_timeout() -> void:
	set_laser_state(laserState.TRACKING)
