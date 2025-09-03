extends Label

#connect this the score label with the score manager
func _ready():
	ScoreManager.scoreUpdated.connect(updateText)
	updateText(ScoreManager.score)
	
#updates the score each time
func updateText(newScore: int):
	text = "Score: " + str(newScore)
