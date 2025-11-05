extends Area2D

@onready var bone_scene: PackedScene = preload("res://Bone.tscn")
@onready var flame_scene: PackedScene = preload("res://Flame.tscn")
@onready var root: Node2D = get_parent()
@onready var block: StaticBody2D = root.get_node("Block")
@onready var break_sound: AudioStreamPlayer2D = $BreakSound2D

func _ready() -> void:
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name != "player":
		return

	# Play break sound
	if break_sound:
		break_sound.play()

	# Spawn item (Bone or Flame)
	var item_scene: PackedScene = bone_scene if randf() < 0.5 else flame_scene
	var item: Node2D = item_scene.instantiate()
	root.get_parent().add_child(item)
	item.global_position = global_position + Vector2(0, -16)

	# Remove top collider
	if block:
		block.queue_free()

	# Remove this BreakableBox after short delay to let sound play
	await get_tree().create_timer(0.1).timeout
	root.queue_free()
