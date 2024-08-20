extends Control

signal quitFromMenu(value)

# Called when the node enters the scene tree for the first time.
func _ready():
	$confirmQuit.hide()
	$optionsButton.disabled = true

func _on_quit_button_pressed():
	quitFromMenu.emit(2)
	$confirmQuit.show()

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://scenes/test.tscn")
