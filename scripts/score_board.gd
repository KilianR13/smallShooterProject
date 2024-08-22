extends Control

var playerScore
var enemyScore

func updateScore(playerNewScore , enemyNewScore):
	enemyScore = enemyNewScore
	playerScore = playerNewScore
	$updateTimer.start()


func _on_update_timer_timeout():
	$enemyScore.text = str(enemyScore)
	$playerScore.text = str(playerScore)
	$updateScoreBell.play()
