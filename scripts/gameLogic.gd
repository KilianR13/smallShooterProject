extends Node2D

@onready var spawnBarriers = $spawnBarriers.get_children()
@onready var camera = $gameCamera
@onready var pause_Menu = $gameCamera/pauseMenu
@onready var gameEndScreen = $gameCamera/gameEndScreen
@onready var scoreBoard = $gameCamera/scoreBoard
@onready var titleMapLight = $NavigationRegion2D/TileMap
var rng = RandomNumberGenerator.new()
var playerPoints = 0
var enemyPoints = 0
var winScore = 5
var paused = false
var regularShadowsType: bool = false
var canPause: bool


#$NavigationRegion2D/TileMap.get_material().set_light_mode(2)

# Called when the node enters the scene tree for the first time.
func _ready():
	if regularShadowsType:
		titleMapLight.get_material().set_light_mode(2)
	elif !regularShadowsType:
		titleMapLight.get_material().set_light_mode(0)
	pause_Menu.hide()
	gameEndScreen.hide()
	scoreBoard.hide()
	$player.stopMovement()
	$enemy.stopMovement()
	roundStart()	
	#Input.mouse_mode = Input.MOUSE_MODE_CONFINED

# DEBUG
func changeShadowStyle():
	regularShadowsType = !regularShadowsType

# Called every frame. 'delta' is the elapsed time since the previous frame.
# DEBUG
func _process(_delta):
	if regularShadowsType:
		titleMapLight.get_material().set_light_mode(2)
	elif !regularShadowsType:
		titleMapLight.get_material().set_light_mode(0)

func _unhandled_key_input(_event):
	if Input.is_action_just_pressed("pause") and canPause:
		print(canPause)
		pauseMenu()

func pauseMenu():
	if paused:
		pause_Menu.hide()
		$player.playerLight.show()
		$player/playerHUD.show()
		Engine.time_scale = 1
		$player.resumeMovement()
		$enemy.resumeMovement()
	else:
		pause_Menu.show()
		$player.playerLight.hide()
		$player/playerHUD.hide()
		Engine.time_scale = 0
		$player.stopMovement()
		$enemy.stopMovement()
	
	paused = !paused

# When the timer to start the match ends, all barriers containing the player and the enemy are disabled
func _on_match_start_timer_timeout():
	$roundStartBell.play()
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
	canPause = false
	camera.apply_shake()
	$killSound.play()
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
	if playerPoints >= winScore: # Yes
		gameOver(true) # Player wins
		canPause = false
	elif enemyPoints >= winScore: # He doesn't, but the enemy does
		gameOver(false) # The enemy wins
		canPause = false
	else: # Neither has enough points
		$newMatchWaitTimer.start() # Start the timer for a new match
		scoreBoard.show()
		scoreBoard.updateScore(playerPoints , enemyPoints)

func playAgain():
	playerPoints = 0
	enemyPoints = 0
	canPause = true
	$newMatchWaitTimer.start()

func gameOver(playerWon : bool):
	canPause = false
	gameEndScreen.show()
	gameEndScreen.changeByWinner(playerWon)
	$endOfGameCheers.play()

# Function called when the timer for a new match runs out
func _on_new_match_wait_timer_timeout():
	# A new round starts
	scoreBoard.hide()
	canPause = true
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



func _on_game_end_screen_play_again():
	playAgain()
