extends CanvasLayer

static var image = load("res://assets/Diamond/Sprite-0005.png")


func setHealth(amount):
	#remove all children
	for child in $health/HBoxContainer.get_children():
		child.queue_free()
	
	#create new children amount set by health
	for i in amount:
		var textRect = TextureRect.new()
		textRect.texture = image
		$health/HBoxContainer.add_child(textRect)
		textRect.stretch_mode = TextureRect.STRETCH_KEEP
		
