extends Control

@export var levelScene: PackedScene


func _process(_delta):
	if Input.is_action_just_pressed("ui_space"):
		get_tree().change_scene_to_packed(levelScene)
		ScoreManager.score = 0
	
