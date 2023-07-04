class_name AnimationPlayerHurt
extends AnimationPlayer

func on_hurt():
	play("hurt")

func _on_health_hurt(_dmg):
	on_hurt()
