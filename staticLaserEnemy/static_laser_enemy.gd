extends Area2D

@export var warningTime := 3.0
@export var mainLaserTIme := 3.0
@export var cooldownTime = 1.0

var playerPosition
var targetPosition
var rng := RandomNumberGenerator.new()

@onready var enemyLaser = $enemyLaser
@onready var warningLaser = $enemyWarningLine
@onready var shootTimer: Timer = $shootTimer
@onready var player = get_tree().get_first_node_in_group("player")

enum laserState {IDLE, WARNING, MAIN}
var currentState := laserState.IDLE
var stateTimer := 0.0

signal collision

func _ready():
	#Spawn points
	var width = get_viewport().get_visible_rect().size[0]
	var randomX = rng.randi_range(0,width)
	var randomY = rng.randi_range(10,610)
	position = Vector2(randomX,randomY)
	
	#start with warning line
	set_laser_state(laserState.WARNING)
	
func _physics_process(delta: float) -> void:
	playerPosition = player.position
	targetPosition = (playerPosition - position).normalized()
	look_at(playerPosition)
	
	#countdown
	stateTimer -= delta
	if stateTimer <= 0.0:
		match currentState:
			laserState.WARNING:
				set_laser_state(laserState.MAIN)
			laserState.MAIN:
				set_laser_state(laserState.IDLE)
			laserState.IDLE:
				set_laser_state(laserState.WARNING)
	
#Center control
func set_laser_state(newState: int) -> void:
	if currentState == newState:
		return
	
	currentState = newState
	
	match newState:
		laserState.WARNING:
			warningLaser.isCasting = true
			enemyLaser.isCasting = false
			stateTimer = warningTime
		laserState.MAIN:
			warningLaser.isCasting = false
			enemyLaser.isCasting = true
			stateTimer = mainLaserTIme
		laserState.IDLE:
			warningLaser.isCasting = false
			enemyLaser.isCasting = false
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
