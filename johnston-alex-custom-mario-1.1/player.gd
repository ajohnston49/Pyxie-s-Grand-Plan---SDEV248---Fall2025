extends CharacterBody2D

@onready var anim := $AnimatedSprite2D

const SPEED := 200
const JUMP_FORCE := -500
var gravity := ProjectSettings.get_setting("physics/2d/default_gravity")

var is_big := false  # Starts small

func _ready():
	is_big = false
	anim.play("Idle_small")
	anim.flip_h = false  # Optional: reset facing

func _physics_process(delta):
	var velocity := self.velocity

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	var input_direction := Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_direction * SPEED

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# Apply movement
	self.velocity = velocity
	move_and_slide()

	# Animation logic
	if input_direction == 0:
		if is_big:
			anim.play("Idle")
		else:
			anim.play("Idle_small")
	else:
		if is_big:
			if input_direction < 0:
				anim.play("Move_left")
			else:
				anim.play("Move_right")
		else:
			anim.flip_h = input_direction < 0
			anim.play("Move_small")

	# Stomp check
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider and collider.has_method("check_stomp"):
			collider.check_stomp(self)

func grow():
	is_big = true
	anim.play("Idle")  # Switch to big idle

var score := 0  # Temporary score tracker

func add_point():
	score += 1
	print("Score: %d" % score)
	# TODO: connect this to HUD later

func take_damage():
	if is_big:
		is_big = false
		anim.play("Idle_small")
	else:
		anim.play("Die_small")
		# TODO: trigger game over logic

func bounce():
	velocity.y = JUMP_FORCE / 2
