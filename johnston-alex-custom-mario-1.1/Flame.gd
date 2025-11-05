extends Area2D

func _ready():
	monitoring = true
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "player":
		if body.has_method("grow"):
			body.grow()
		queue_free()
