extends Node2D

@onready var spawnBarriers = $spawnBarriers.get_children()

# Called when the node enters the scene tree for the first time.
func _ready():
	$player.position = $playerSpawn.position
	$enemy.position = $enemySpawn.position
	$matchStartTimer.start()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_match_start_timer_timeout():
	for barrier in spawnBarriers:
		barrier.disabled = true
