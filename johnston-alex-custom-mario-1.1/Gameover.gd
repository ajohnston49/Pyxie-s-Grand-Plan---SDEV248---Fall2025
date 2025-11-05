extends CanvasLayer

@onready var restart_button: Button = $Button

func _ready() -> void:
	restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")  # Or your main game scene
