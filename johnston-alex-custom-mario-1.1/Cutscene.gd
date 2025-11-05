extends CanvasLayer

func _ready():
	$start.visible = true
	$start2.visible = false

	await get_tree().create_timer(5.0).timeout
	$start.visible = false
	$start2.visible = true

	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://world.tscn")
