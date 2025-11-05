extends CanvasLayer

@onready var intro_text = $IntroText
@onready var start_button = $StartButton

func _ready():
	intro_text.text = """The storm just ended.
You are a pixie — fragile, glowing, and alone.

The world is soaked and crawling with liquid beasts.
Your only goal: survive the journey back to safety.

Jump, dodge, and spark your way through the flood.
Your light is the only thing left."""
	
	start_button.pressed.connect(_on_start_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Cutscene.tscn")  # Replace with your actual level scene path
