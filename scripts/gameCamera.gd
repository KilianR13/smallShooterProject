extends Camera2D

@export var randomStrength: float = 10.0
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new()
var shake_strength: float = 0.0

# Function called whenever the player or the enemy is hit
func apply_shake():
	# Make the shake strength the randomStrength value
	shake_strength = randomStrength

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Is the shake strength more than 0?
	if shake_strength > 0: # Yes
		
		# Make the shake strength a lerp using the shake strength, towards 0, with a rythm of shakeFade multiplied by Delta
		shake_strength = lerpf(shake_strength, 0, shakeFade * delta)
		
		# Make the offset of the camera the result of the randomOffset function
		offset = randomOffset()

# Function that returns a Vector2 with random coordinates using a random range from a Random Number Generator
func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shake_strength,shake_strength),rng.randf_range(-shake_strength,shake_strength))
