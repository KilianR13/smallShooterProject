extends RigidBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var enemy = get_tree().get_first_node_in_group("enemy")

# Called when the node enters the scene tree for the first time.
func _ready():
	# Establishes the position the bullet is spawned in.
	# The equation makes it so the bullet actually spawns 20 pixels beyond the enemy, so it doesn't cause weird clippings
	position = enemy.position + (player.position - enemy.position).normalized() * 20
	# The linear velocity is calculated so it behaves like an actual bullet
	self.linear_velocity = (player.position - position).normalized() * 2000
	# The bullet will look at the player to make it look like it's actually being shot towards the player
	self.look_at((player.position - position).normalized())

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("tileMap") or body.is_in_group("playerBullet"):
		queue_free()

# Function to check if the enemy's bullet has hit the players's hitbox area.
# The hitbox area is different from the collision, and uses an area.
func _on_area_2d_area_entered(area):
	if area.is_in_group("playerHitbox"):
		queue_free()
