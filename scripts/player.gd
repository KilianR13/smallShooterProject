extends CharacterBody2D

const BULLET = preload("res://scenes/bullet.tscn")
const SPEED = 250.0
const MAX_AMMO = 12

var gunshotSound_player = AudioStreamPlayer2D.new()
var gunshotSound = preload("res://resources/soundFX/gunshot_sound_player.wav")
var canMove: bool = true
var gunAmmo
@onready var reloadSound = $reloadSoundAudioPlayer


signal playerHit
signal gunshot
signal reloaded

func _ready():
	gunAmmo = MAX_AMMO
	gunshotSound_player.stream = gunshotSound
	gunshotSound_player.volume_db = -10
	gunshotSound_player.finished.connect(_on_gunshot_sound_finished)
	#Input.MOUSE_MODE_CAPTURED
	#self.position = get_viewport_rect().size/2
	pass

func _physics_process(_delta):
	if canMove:
		# Puts the current position of the mouse in a variable to use it multiple times
		var currentMousePosition = get_global_mouse_position()
		# Rotates the sprite to make it look at the cursor at all times
		self.look_at(currentMousePosition)
		if !reloadSound.playing:
			# Function for shooting
			if Input.is_action_just_pressed("shootMain") and gunAmmo >= 1:
				gunshotSound_player.set_pitch_scale(randf_range(0.7, 0.75))
				add_child(gunshotSound_player)
				gunshotSound_player.play()
				var shoot = BULLET.instantiate()
				get_parent().add_child.call_deferred(shoot) # The bullet will shoot instantly.
				gunAmmo -= 1
				gunshot.emit()
			elif Input.is_action_just_pressed("shootMain") and gunAmmo == 0:
				reloadGun()
	
		# Get the input direction and handle the movement/deceleration.
		var xDir = Input.get_axis("moveLeft","moveRight")
		var yDir = Input.get_axis("moveUp","moveDown")
		var movement2D = Vector2(xDir,yDir)
			
		if movement2D != Vector2.ZERO:
			velocity = movement2D * SPEED
			$animatedPlayerSprite.play("walking")
		else:
			velocity = velocity.move_toward(Vector2(0,0), SPEED)
			$animatedPlayerSprite.play("idle")
	
	move_and_slide()

func _unhandled_input(_event):
	if Input.is_action_just_pressed("reloadGun") and gunAmmo < MAX_AMMO and !reloadSound.playing:
		reloadGun()

func _on_player_hitbox_area_entered(area):
	if area.is_in_group("enemyBulletArea"): # Yes
		# It should be used for the game logic
		playerHit.emit()

func _on_gunshot_sound_finished():
	remove_child(gunshotSound_player)

func stopMovement():
	canMove = false

func resumeMovement():
	canMove = true

func reloadGun():
	reloadSound.play()
	print("reloading")

func newRound():
	gunAmmo = MAX_AMMO
	reloaded.emit()

func _on_reload_sound_audio_player_finished():
	gunAmmo = MAX_AMMO
	reloaded.emit()
