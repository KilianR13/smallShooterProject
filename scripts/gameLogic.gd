extends Node2D

@onready var spawnBarriers = $spawnBarriers.get_children()
var playerPoints = 0
var enemyPoints = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	roundStart()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_match_start_timer_timeout():
	for barrier in spawnBarriers:
		barrier.disabled = true

# Function called when a new round starts
func roundStart():
	# Sets the player 
	$player.position = $playerSpawn.position
	$enemy.position = $enemySpawn.position
	$player.show()
	$enemy.show()
	$player.resumeMovement()
	$enemy.resumeMovement()
	
	for barrier in spawnBarriers:
		barrier.disabled = false
	$matchStartTimer.start()
	

func roundOver():
	$player.hide()
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


func _on_enemy_enemy_hit():
	playerPoints += 1
	roundOver()


func _on_player_player_hit():
	playerPoints += 1
	roundOver()
