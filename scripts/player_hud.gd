extends CanvasLayer

@onready var player = get_tree().get_first_node_in_group("player")

# Called when the node enters the scene tree for the first time.
func _ready():
	checkPlayerAmmo()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	$ammoCount.position = player.position - (Vector2(10.0,50.0))

func checkPlayerAmmo():
	$ammoCount.set_text(str(player.gunAmmo))

func _on_player_gunshot():
	checkPlayerAmmo()


func _on_player_reloaded():
	checkPlayerAmmo()
