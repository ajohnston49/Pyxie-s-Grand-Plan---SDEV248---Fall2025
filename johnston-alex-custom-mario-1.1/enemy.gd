extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var stomp_box: Area2D = $StompBox
@onready var attack_box: Area2D = $AttackBox

const SPEED: int = 50
var direction: int = -1
var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")
var is_dead: bool = false

func _ready() -> void:
	if stomp_box:
		stomp_box.body_entered.connect(_on_stomp_box_body_entered)
	if attack_box:
		attack_box.body_entered.connect(_on_attack_box_body_entered)

func _physics_process(delta: float) -> void:
	if is_dead:
		return

	velocity.y += gravity * delta
	velocity.x = direction * SPEED
	move_and_slide()

	if is_on_wall():
		direction *= -1

	anim.flip_h = direction < 0
	anim.play("Move_right")

func _on_stomp_box_body_entered(body: Node) -> void:
	if is_dead or body == null:
		return
	if body.name == "player":
		body.bounce()
		die()

func _on_attack_box_body_entered(body: Node) -> void:
	if is_dead or body == null:
		return
	if body.name == "player" and body.has_method("take_enemy_hit"):
		body.take_enemy_hit()

func check_stomp(body: Node) -> void:
	if is_dead or body == null:
		return
	if body.name == "player":
		body.bounce()
		$SplashSound.play()
		die()

func die() -> void:
	is_dead = true
	velocity = Vector2.ZERO
	set_physics_process(false)

	anim.play("squashed")
	anim.frame = 0
	anim.speed_scale = 1.0

	if stomp_box:
		stomp_box.set_deferred("monitoring", false)
	if attack_box:
		attack_box.set_deferred("monitoring", false)

	await get_tree().create_timer(0.4).timeout
	queue_free()
