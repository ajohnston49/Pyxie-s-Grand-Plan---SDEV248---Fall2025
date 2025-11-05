extends CanvasLayer

@onready var restart_button: Button = $Button  # Update path if nested

func _ready() -> void:
	if restart_button:
		restart_button.pressed.connect(_on_restart_pressed)

func _on_restart_pressed() -> void:
	get_tree().change_scene_to_file("res://world.tscn")  # Or your main game scene
