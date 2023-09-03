class_name AnimPlayerHurt
extends AnimationPlayer

func on_hurt():
	play("hurt")
	Script

func _on_health_hurt(_dmg):
	on_hurt()
