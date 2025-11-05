extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_sound: AudioStreamPlayer2D = $JumpSound

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
const SPEED: int = 200
const JUMP_FORCE: int = -500

var is_big: bool = false
var score: int = 0
var can_be_hit: bool = true

var bone_label: Label = null

func _ready() -> void:
	is_big = false
	can_be_hit = true
	anim.play("Idle_small")
	anim.flip_h = false

	# Safely get HUD label
	var hud_path := "/root/World/HUD/BoneLabel"  # Replace 'World' with your actual root node name
	if has_node(hud_path):
		bone_label = get_node(hud_path)
	else:
		print("⚠ BoneLabel not found at:", hud_path)

	update_hud()

func _physics_process(delta: float) -> void:
	var velocity: Vector2 = self.velocity

	# Gravity
	if not is_on_floor():
		velocity.y += gravity * delta

	# Horizontal movement
	var input_direction: float = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.x = input_direction * SPEED

	# Jump
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		jump_sound.play()

	self.velocity = velocity
	move_and_slide()

	# Animation logic
	if input_direction == 0:
		anim.play("Idle" if is_big else "Idle_small")
	else:
		if is_big:
			anim.play("Move_left" if input_direction < 0 else "Move_right")
		else:
			anim.flip_h = input_direction < 0
			anim.play("Move_small")

	# Stomp detection
	for i in get_slide_collision_count():
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()
		if collider and collider.has_method("check_stomp"):
			collider.check_stomp(self)

func grow() -> void:
	is_big = true
	anim.flip_h = false
	anim.play("Idle")

func take_enemy_hit() -> void:
	if is_big:
		if not can_be_hit:
			return
		can_be_hit = false
		is_big = false
		anim.flip_h = false
		anim.play("Idle_small")
		await get_tree().create_timer(1.0).timeout
		can_be_hit = true
	else:
		anim.play("Die_small")
		set_physics_process(false)
		await get_tree().create_timer(0.4).timeout
		get_tree().change_scene_to_file("res://GameOverMenu.tscn")

func bounce() -> void:
	velocity.y = JUMP_FORCE / 2

func add_point() -> void:
	score += 1
	update_hud()
	print("Score: %d" % score)

func update_hud() -> void:
	if bone_label:
		bone_label.text = "Bones: %d" % score
