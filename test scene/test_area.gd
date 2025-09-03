extends Node2D

var enemy_scene: PackedScene = load("res://enemy/enemy.tscn")

var health: int = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#health ui setup
	get_tree().call_group("ui", "setHealth", health)

# Enemy Spawner
func _on_enemy_timer_timeout() -> void:
	var enemy = enemy_scene.instantiate()
	
	$enemies.add_child(enemy)
	
	enemy.connect("collision", on_enemy_collision)
	
func on_enemy_collision():
	health -= 1
	get_tree().call_group("ui", "setHealth", health)
	
	
	if health <= 0:
		get_tree().change_scene_to_file("res://game over/game_over.tscn")
