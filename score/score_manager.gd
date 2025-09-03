extends Node

#this is a global autoload in the project settings

var score: int = 0
signal scoreUpdated


#manages the score
func add_score(amount: int):
	score += amount
	scoreUpdated.emit(score)
