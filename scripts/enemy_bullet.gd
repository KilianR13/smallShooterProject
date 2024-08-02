extends RigidBody2D

@onready var player = get_tree().get_first_node_in_group("player")
@onready var enemy = get_tree().get_first_node_in_group("enemy")

# Called when the node enters the scene tree for the first time.
func _ready():
	print(str(player.position - position))
	position = enemy.position
	self.linear_velocity = (player.position - position).normalized()  * 2000
	self.look_at((player.position - position).normalized())


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


#func _on_visible_on_screen_notifier_2d_screen_exited():
	#queue_free()


func _on_area_2d_body_entered(body):
	if body.is_in_group("tileMap"):
		queue_free()
