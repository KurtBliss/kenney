# autoload/ref.gd
extends Node

var player : Player
var level : Level
var tilemap : TileMap

func _process(_delta):
	if Input.is_action_just_pressed("restart"):
		get_tree().reload_current_scene()
