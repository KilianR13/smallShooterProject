extends CharacterBody2D

const ENEMY_MOVEMENT_SPEED = 100
const WALL_AVOIDANCE_FORCE = 200
const BULLET = preload("res://scenes/enemy_bullet.tscn")
var preventLoop : bool = false

signal enemy_dead
@onready var player = get_tree().get_first_node_in_group("player")
@onready var raycastEnemyAim = $rayCastAim

@export var player_path : NodePath

var motion

@onready var nav_agent = $NavigationAgent2D

func _ready():
	# The raycast used to shoot is disabled when loading to prevent weird errors
	raycastEnemyAim.enabled = false
	# The raycast will not detect the enemy itself
	raycastEnemyAim.add_exception(self)
	# Extends the raycast
	raycastEnemyAim.set_target_position(raycastEnemyAim.get_target_position() * 200)

func _physics_process(delta):
	# Set a Vector2.Zero for the motion. Idk why but it doesn't work if you don't
	motion = Vector2.ZERO
	# Set the target position for the nav agent to the player
	# This MUST be changed when making the AI. It can't be used every frame and the enemy must not know where the player is always
	nav_agent.set_target_position(player.global_position)
	# Set the next nav point for the enemy
	var next_nav_point = nav_agent.get_next_path_position()
	# The velocity is set towards the next navigation point
	velocity = (next_nav_point - global_position).normalized() * ENEMY_MOVEMENT_SPEED
	# Make the enemy always look at the player. This will have to change later.
	look_at(Vector2(player.global_position.x, player.global_position.y))
	# Check for raycast collision to prepare to shoot.
	checkRayCastCollision()
	move_and_slide()

func _on_hitbox_area_area_entered(area):
	# Is the "area" that just entered the enemy's area in the "playerBulletArea" group?
	if area.is_in_group("playerBulletArea"): # Yes
		# It should be used for the game logic
		print("enemy hit")

func checkRayCastCollision():
	# "Is the raycast colliding with the player?"
	if raycastEnemyAim.is_colliding() and raycastEnemyAim.get_collider() == player: # Yes
		# "Is the timer for shooting stopped?"
		if $shootTimer.is_stopped(): # Yes
			# Start the timer to decide if the enemy should shoot
			$shootTimer.start()


func _on_shoot_timer_timeout():
	# "Is the raycast STILL colliding with the player?"
	if raycastEnemyAim.is_colliding() and raycastEnemyAim.get_collider() == player: # Yes
		# Instantiate a bullet into a variable and add it as a child to the enemy
		var shoot = BULLET.instantiate()
		get_parent().add_child.call_deferred(shoot)
		# Make sure the timer is stopped, for good measure
		$shootTimer.stop()

# This timer only re-enables the raycast to shoot once 2 seconds pass after the start of the match
func _on_ray_cast_enabler_timer_timeout():
	raycastEnemyAim.enabled = true
