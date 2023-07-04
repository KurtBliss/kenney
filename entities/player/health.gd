extends Node

@onready var player = $".."
@onready var camera_2d = $"../Camera2D"

func _process(_delta):
	if player.health <= 0: 
		camera_2d.reparent(ref.level)
		player.queue_free()
