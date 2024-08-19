extends Control

signal quitFromPause(value)

@onready var main = $"../../"
@onready var confirmQuitMenu = $confirmQuit

func _ready():
	confirmQuitMenu.hide()
	pass

func _unhandled_key_input(_event):
	if Input.is_action_just_pressed("pause"):
		confirmQuitMenu.hide()

func _on_resume_button_pressed():
	main.pauseMenu()


func _on_quit_button_pressed():
	quitFromPause.emit(1)
	confirmQuitMenu.show()

# DEBUG SHADOWS
func _on_debug_shadows_pressed():
	main.changeShadowStyle()
