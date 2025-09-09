extends Node2D

var meleeEnemyScene: PackedScene = load("res://enemy/enemy.tscn")
var staticRangedEnemiesScene: PackedScene = load("res://static_enemy.tscn")
var enemyBulletScene: PackedScene = load("res://enemy_bullet.tscn")

var health: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#health ui setup
	get_tree().call_group("ui", "setHealth", health)

	#Enemy Bullet Collision
	var staticEnemyBullet = enemyBulletScene.instantiate()
	
	staticEnemyBullet.connect("enemyBulletCollision", on_static_enemy_bullet_collision)
	
func on_enemy_collision():
	health -= 1
	get_tree().call_group("ui", "setHealth", health)
	
	if health <= 0:
		get_tree().change_scene_to_file("res://game over/game_over.tscn")

# Melee Enemy Spawner
func _on_melee_enemy_timer_timeout() -> void:
	var meleeEnemy = meleeEnemyScene.instantiate()
	
	$meleeEnemies.add_child(meleeEnemy)
	
	meleeEnemy.connect("collision", on_enemy_collision)
	
	
func on_static_enemy_collision():
	health -=1
	get_tree().call_group("ui", "setHealth", health)
	
	if health <= 0:
		get_tree().change_scene_to_file("res://game over/game_over.tscn")

func _on_static_ranged_enemy_timer_timeout() -> void:
	var staticRangedEnemy = staticRangedEnemiesScene.instantiate()
	
	$staticRangedEnemies.add_child(staticRangedEnemy)
	
	staticRangedEnemy.connect("collision", on_static_enemy_collision)

func on_static_enemy_bullet_collision():
	
	health -=1
	get_tree().call_group("ui", "setHealth", health)
	
	if health <= 0:
		get_tree().change_scene_to_file("res://game over/game_over.tscn")
	
	print("Receiving Signal")
