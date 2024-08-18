extends CharacterBody2D

var enemyMovementSpeed = 100
const BULLET = preload("res://scenes/enemy_bullet.tscn")
const MAX_AMMO = 12
var preventLoop : bool = false
var gunshotSound_player = AudioStreamPlayer2D.new()
var gunshotSound = preload("res://resources/soundFX/gunshot_sound_enemyV2.wav")
var canMove: bool = true
var gunAmmo

enum enemyPlaystyle {
	NORMAL,
	RANDOM,
	RUSH,
}

var enemyState
var rng = RandomNumberGenerator.new()

signal enemyHit

@onready var reloadSound = $reloadSoundAudioPlayer
@onready var player = get_tree().get_first_node_in_group("player")
@onready var raycastEnemyAim = $rayCastAim
@export var player_path : NodePath

var motion
var next_nav_point

@onready var nav_agent = $NavigationAgent2D

func _ready():
	# The raycast used to shoot is disabled when loading to prevent weird errors
	raycastEnemyAim.enabled = false
	# The raycast will not detect the enemy itself
	raycastEnemyAim.add_exception(self)
	# Extends the raycast
	raycastEnemyAim.set_target_position(raycastEnemyAim.get_target_position() * 200)
	gunshotSound_player.stream = gunshotSound
	gunshotSound_player.volume_db = -5
	gunshotSound_player.set_pitch_scale(0.8)
	gunshotSound_player.finished.connect(_on_gunshot_sound_finished)
	# Making sure that the enemy's handgun is filled
	gunAmmo = MAX_AMMO
	
func _physics_process(_delta):
	if canMove:
		# Set a Vector2.Zero for the motion. Idk why but it doesn't work if you don't
		motion = Vector2.ZERO
		# Set the target position for the nav agent to the player
		# This MUST be changed when making the AI. It can't be used every frame and the enemy must not know where the player is always
		nav_agent.set_target_position(player.global_position)
		# Set the next nav point for the enemy
		if $checkPlayerPositionTimer.is_stopped():
			$checkPlayerPositionTimer.start()
			next_nav_point = nav_agent.get_next_path_position()
			# The velocity is set towards the next navigation point
			velocity = (next_nav_point - global_position).normalized() * enemyMovementSpeed
			# Make the enemy always look at the player. This will have to change later.
			look_at(Vector2(player.global_position.x, player.global_position.y))
			$animatedEnemySprite.play("walking")
	elif !canMove:
		$animatedEnemySprite.play("idle")
	# Check for raycast collision to prepare to shoot.
	checkRayCastCollision()
	move_and_slide()

func _on_hitbox_area_area_entered(area):
	# Is the "area" that just entered the enemy's area in the "playerBulletArea" group?
	if area.is_in_group("playerBulletArea"): # Yes
		# It should be used for the game logic
		enemyHit.emit()
		$playstyleChangeTimer.stop()

func checkRayCastCollision():
	if canMove:
		# "Is the raycast colliding with the player?"
		if raycastEnemyAim.is_colliding() and raycastEnemyAim.get_collider() == player: # Yes
				# "Is the timer for shooting stopped?"
			if $shootTimer.is_stopped(): # Yes
					# Start the timer to decide if the enemy should shoot
				$shootTimer.start()

func _on_shoot_timer_timeout():
	# "Is the raycast STILL colliding with the player?"
	if raycastEnemyAim.is_colliding() and raycastEnemyAim.get_collider() == player and gunAmmo >= 1: # Yes
		# Instantiate a bullet into a variable and add it as a child to the enemy
		var shoot = BULLET.instantiate()
		get_parent().add_child.call_deferred(shoot)
		gunAmmo -= 1
		add_child(gunshotSound_player)
		gunshotSound_player.play()
		# Make sure the timer is stopped, for good measure
		$shootTimer.stop()
	elif raycastEnemyAim.is_colliding() and raycastEnemyAim.get_collider() == player and gunAmmo == 0 and !reloadSound.playing:
		# Make sure the timer is stopped, for good measure
		$shootTimer.stop()
		reloadSound.play()

# This timer only re-enables the raycast to shoot once 2 seconds pass after the start of the match
func _on_ray_cast_enabler_timer_timeout():
	raycastEnemyAim.enabled = true

func _on_gunshot_sound_finished():
	remove_child(gunshotSound_player)

func stopMovement():
	canMove = false

func resumeMovement():
	canMove = true

func generateRandom3() -> int:
	return rng.randi_range(0, 2)

func _on_reload_sound_audio_player_finished():
	gunAmmo = MAX_AMMO

func newRound():
	$playstyleChangeTimer.start()
	# Choose one of the possible strategies at random
	makeStrategy()
	gunAmmo = MAX_AMMO

func makeStrategy():
	enemyState = enemyPlaystyle.values()[generateRandom3()]
	match enemyState:
		enemyPlaystyle.RUSH:
			$shootTimer.set_wait_time(0.2)
			$checkPlayerPositionTimer.set_wait_time(0.1)
			enemyMovementSpeed = 300
			print("1")
		enemyPlaystyle.RANDOM:
			$shootTimer.set_wait_time(rng.randf_range(0.2, 0.4))
			enemyMovementSpeed = rng.randi_range(80, 200)
			$checkPlayerPositionTimer.set_wait_time(0.2)
			print("2")
		enemyPlaystyle.NORMAL:
			$shootTimer.set_wait_time(0.3)
			enemyMovementSpeed = 100
			$checkPlayerPositionTimer.set_wait_time(0.2)
			print("3")
			pass

func _on_playstyle_change_timer_timeout():
	if rng.randi_range(0, 1) == 1:
		makeStrategy()
		print("new strategy!")
	else:
		print("no new strategy")
