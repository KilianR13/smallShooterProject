extends Node2D

@onready var spawnBarriers = $spawnBarriers.get_children()
@onready var camera = $gameCamera
@onready var pause_Menu = $gameCamera/pauseMenu
var playerPoints = 0
var enemyPoints = 0
var paused = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_Menu.hide()
	$player.stopMovement()
	$enemy.stopMovement()
	roundStart()
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_key_input(event):
	if Input.is_action_just_pressed("pause"):
		pauseMenu()

func pauseMenu():
	if paused:
		pause_Menu.hide()
		Engine.time_scale = 1
		$player.resumeMovement()
		$enemy.resumeMovement()
	else:
		pause_Menu.show()
		Engine.time_scale = 0
		$player.stopMovement()
		$enemy.stopMovement()
	
	paused = !paused

# When the timer to start the match ends, all barriers containing the player and the enemy are disabled
func _on_match_start_timer_timeout():
	for barrier in spawnBarriers:
		barrier.disabled = true
	# Calls the function that allowes the player and enemy to resume movement
	$player.resumeMovement()
	$enemy.resumeMovement()

# Function called when a new round starts
func roundStart():
	# Sets the player and the enemy's starter position, just to make sure.
	$player.position = $playerSpawn.position
	$enemy.position = $enemySpawn.position
	# Reveals the player and the enemy
	$player.show()
	$player/playerHUD.show()
	$enemy.show()
	$player.newRound()
	$enemy.newRound()
	for barrier in spawnBarriers:
		barrier.disabled = false
	$matchStartTimer.start()
	

func roundOver():
	camera.apply_shake()
	stopMoving()
	$player.hide()
	$player/playerHUD.hide()
	$enemy.hide()
	$player.position = $playerSpawn.position
	$player.stopMovement()
	$enemy.position = $enemySpawn.position
	$enemy.stopMovement()
	checkWinner()

# Function called every time a round is over. It decides if a new round should start or not
func checkWinner():
	# Does the player have the required ammount of points to win?
	if playerPoints >= 5: # Yes
		print("Player wins") # Player wins
	elif enemyPoints >= 5: # He doesn't, but the enemy does
		print("Enemy wins") # The enemy wins
	else: # Neither has enough points
		$newMatchWaitTimer.start() # Start the timer for a new match

# Function called when the timer for a new match runs out
func _on_new_match_wait_timer_timeout():
	# A new round starts()
	roundStart()

func stopMoving():
	$player.velocity = Vector2(0,0)
	$enemy.velocity = Vector2(0,0)

func _on_enemy_enemy_hit():
	playerPoints += 1
	roundOver()


func _on_player_player_hit():
	enemyPoints += 1
	roundOver()

