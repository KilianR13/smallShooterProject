extends CharacterBody2D

const ENEMY_MOVEMENT_SPEED = 100
const WALL_AVOIDANCE_FORCE = 200
const BULLET = preload("res://scenes/enemy_bullet.tscn")

signal enemy_dead
@onready var player = get_tree().get_first_node_in_group("player")
@onready var raycasts = $rayCastNode.get_children()

@export var player_path : NodePath

var motion

@onready var nav_agent = $NavigationAgent2D

func _ready():
	for i in range(raycasts.size()):
		if raycasts[i] is RayCast2D:
			raycasts[i].add_exception(self)
			raycasts[i].set_target_position(raycasts[i].get_target_position() * 200)

func _physics_process(delta):
	motion = Vector2.ZERO
	nav_agent.set_target_position(player.global_position)
	var next_nav_point = nav_agent.get_next_path_position()
	velocity = (next_nav_point - global_position).normalized() * ENEMY_MOVEMENT_SPEED
	
	look_at(Vector2(player.global_position.x, player.global_position.y))
	#motion += self.position.direction_to(player.position)
	#velocity = motion * ENEMY_MOVEMENT_SPEED
	#avoid_walls()
	checkRayCastCollision()
	move_and_slide()

func _on_hitbox_area_area_entered(area):
	if area.is_in_group("playerBulletArea"):
		queue_free()
#
#func avoid_walls():
	#var avoid_force = Vector2.ZERO
	#for i in range(raycasts.size()):
		#if raycasts[i] is RayCast2D:
			#if raycasts[i].is_colliding():
				#avoid_force += raycasts[i].get_collision_normal() * WALL_AVOIDANCE_FORCE
	#
	#motion += avoid_force.normalized() * 100
	#pass

func checkRayCastCollision():
	for raycast in raycasts:
		if raycast.is_colliding() and raycast.get_collider() == player:
			var shoot = BULLET.instantiate()
			get_parent().add_child.call_deferred(shoot)
