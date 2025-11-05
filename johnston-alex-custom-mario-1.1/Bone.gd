extends Area2D

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if body.name == "player" and body.has_method("add_point"):
		body.add_point()
		queue_free()
