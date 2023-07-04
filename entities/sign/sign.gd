extends Area2D
@export_multiline var text = ""
@onready var zoom := $Zoom
@onready var label := $Label
@onready var sign := $Sign

func _ready():
	zoom.visible = false
	label.visible = false
	sign.visible = true
	label.text = text

func _on_body_entered(body):
	if not body is Player:
		return
	zoom.visible = true
	label.visible = true
	sign.visible = false

func _on_body_exited(body):
	if not body is Player:
		return
	zoom.visible = false
	label.visible = false
	sign.visible = true

