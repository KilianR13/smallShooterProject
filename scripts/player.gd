extends CharacterBody2D

const BULLET = preload("res://scenes/bullet.tscn")
const SPEED = 250.0

func _ready():
	#Input.MOUSE_MODE_CAPTURED
	#self.position = get_viewport_rect().size/2
	pass

func _physics_process(delta):
	# Puts the current position of the mouse in a variable to use it multiple times
	var currentMousePosition = get_global_mouse_position()
	# Rotates the sprite to make it look at the cursor at all times
	self.look_at(currentMousePosition)
	
	# Function for shooting
	if Input.is_action_just_pressed("shootMain"):
		var shoot = BULLET.instantiate()
		get_parent().add_child.call_deferred(shoot) # The bullet will shoot instantly.
	
	# Get the input direction and handle the movement/deceleration.
	var xDir = Input.get_axis("moveLeft","moveRight")
	var yDir = Input.get_axis("moveUp","moveDown")
	var movement2D = Vector2(xDir,yDir)
	
	if movement2D != Vector2.ZERO:
		velocity = movement2D * SPEED
	else:
		velocity = velocity.move_toward(Vector2(0,0), SPEED)
	#update_raycasts()
	move_and_slide()
