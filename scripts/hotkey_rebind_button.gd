class_name HotkeyRebindButton
extends Control

@onready var label = $HBoxContainer/Label as Label
@onready var button = $HBoxContainer/Button as Button

@export var action_name : String = "moveLeft"

func _ready():
	set_process_unhandled_key_input(false)
	set_action_name()
	set_text_for_key()
	pass

func set_action_name() -> void:
	label.text = "Unassigned"
	
	match action_name:
		"moveLeft":
			label.text = "Move left"
		"moveRight":
			label.text = "Move right"
		"moveUp":
			label.text = "Move up"
		"moveDown":
			label.text = "Move down"
		"shootMain":
			label.text = "Shoot"
		"reloadGun":
			label.text = "Reload"
		"pause":
			label.text = "Pause / Go back"

func set_text_for_key() -> void:
	var actionEvents = InputMap.action_get_events(action_name)
	var actionEvent = actionEvents[0]
	if actionEvent is InputEventKey:
		var actionKeycode = OS.get_keycode_string(actionEvent.physical_keycode)
		button.text = "%s" % actionKeycode
	elif actionEvent is InputEventMouseButton:
		var mouseButton = actionEvent.button_index
		button.text = "%s" % mouseButton
		match mouseButton:
			1:
				button.text = "Left click"
			2:
				button.text = "Right click"
			3:
				button.text = "Middle click"
			4:
				button.text = "Wheel up"
			5:
				button.text = "Wheel down"
			6:
				button.text = "Wheel left"
			7:
				button.text = "Wheel right"
			8:
				button.text = "SpecialMouseButton1"
			9:
				button.text = "SpecialMouseButton2"


func _on_button_toggled(toggled_on):
	if toggled_on:
		button.text = "Press any key..."
		set_process_unhandled_key_input(toggled_on)
		for i in get_tree().get_nodes_in_group("hotkeyButton"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = false
				i.set_process_unhandled_key_input(false)
	else:
		for i in get_tree().get_nodes_in_group("hotkeyButton"):
			if i.action_name != self.action_name:
				i.button.toggle_mode = true
				i.set_process_unhandled_key_input(false)
		set_text_for_key()


func _unhandled_key_input(event):
	rebind_action_key(event)
	button.button_pressed = false

func rebind_action_key(event) -> void:
	InputMap.action_erase_events(action_name)
	InputMap.action_add_event(action_name, event)
	set_process_unhandled_key_input(false)
	set_text_for_key()
	set_action_name()
	pass
