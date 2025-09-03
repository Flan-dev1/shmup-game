extends Label

func _ready():
	ScoreManager.scoreUpdated.connect(scoreUpdate)
	scoreUpdate(ScoreManager.score)

func scoreUpdate(newScore: int):
	text = "Score: " + str(newScore)
