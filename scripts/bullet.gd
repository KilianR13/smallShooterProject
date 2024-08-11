extends Node2D



# Called when the node enters the scene tree for the first time.
func _ready():
	position = get_tree().get_first_node_in_group("player").position
	self.linear_velocity = get_local_mouse_position().normalized() * 3000
	self.look_at(get_local_mouse_position())

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("tileMap") or body.is_in_group("enemyBullet"):
		queue_free()

# Function to check if the player's bullet has hit the enemy's hitbox area.
# The hitbox area is different from the collision, and uses an area.
func _on_area_2d_area_entered(area):
	if area.is_in_group("enemyHitbox"):
		queue_free()
