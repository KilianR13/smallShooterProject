extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	checkPlayerAmmo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$ammoCount.position = player.position - (Vector2(15.0,70.0))

func checkPlayerAmmo():
	if player.gunAmmo == 0:
		$ammoCount.add_theme_color_override("font_color", Color(1, 0, 0))
	else:
		$ammoCount.add_theme_color_override("font_color", Color(1, 1, 1))
	$ammoCount.set_text(str(player.gunAmmo))

func _on_player_gunshot():
	checkPlayerAmmo()


func _on_player_reloaded():
	checkPlayerAmmo()
