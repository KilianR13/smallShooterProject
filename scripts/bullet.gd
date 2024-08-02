extends Node2D

signal enemyHit

# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_tree().get_first_node_in_group("player").position
	self.linear_velocity = get_local_mouse_position().normalized() * 2000
	self.look_at(get_local_mouse_position())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


#func _on_area_2d_area_entered(area):
	#if area.is_in_group("enemy"):
		#queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("tileMap"):
		queue_free()
