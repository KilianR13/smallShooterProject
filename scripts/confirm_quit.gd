extends Control

var typeOfQuit: int

# Function that activates when pressing the button to deny quitting.
# It hides the scene.
func _on_deny_quit_button_pressed():
	self.hide()

# Function that activates when pressing the button to confirm quitting.
# First checks the type of "quitting" required. If it equals "1", it quits to the main menu.
# If it equals "2", it quits the game.
func _on_confirm_quit_button_pressed():
	if typeOfQuit == 1:
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	elif typeOfQuit == 2:
		get_tree().quit()

# Signal coming from the pause menu to confirm quitting
func _on_pause_menu_quit_from_pause(value):
	typeOfQuit = value

# Signal coming from the main menu to confirm quitting
func _on_main_menu_quit_from_menu(value):
	typeOfQuit = value
