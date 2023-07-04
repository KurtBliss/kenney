extends Area2D

@export_file("*.tscn") var scene

func _on_body_entered(body):
	if not body is Player:
		return
	get_tree().change_scene_to_file(scene)
