class_name Level
extends Node2D

func _ready():
	ref.level = self
	if has_node("TileMap"):
		ref.tilemap = get_node("TileMap")
