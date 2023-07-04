class_name EnemyDamage
extends Area2D

func _on_animation_player_hurt_animation_started(_anim_name):
	monitorable = false

func _on_animation_player_hurt_animation_finished(anim_name):
	monitorable = true
