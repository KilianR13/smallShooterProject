extends Control

signal playAgain

# Called when the node enters the scene tree for the first time.
func _ready():
	$replayMatch.disabled = true
	$quitToMenu.disabled = true
	$youLostPNG.hide()
	$youWonPNG.hide()


func changeByWinner(didPlayerWin : bool):
	$antiMissclickTimer.start()
	if didPlayerWin:
		$matchWinnerText.text = "You won!\nCongrats!\n:)"
		$youWonPNG.show()
	elif !didPlayerWin:
		$matchWinnerText.text = "You lost!\nYou suck.\n:("
		$youLostPNG.show()
	else:
		$matchWinnerText.text = "If you're reading this,\nsomething has gone wrong.\n>:("

func _on_replay_match_pressed():
	playAgain.emit()
	$replayMatch.disabled = true
	$quitToMenu.disabled = true
	$youLostPNG.hide()
	$youWonPNG.hide()
	self.hide()


func _on_quit_to_menu_pressed():
	get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")


func _on_anti_missclick_timer_timeout():
	$replayMatch.disabled = false
	$quitToMenu.disabled = false
