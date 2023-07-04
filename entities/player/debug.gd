extends Node
@onready var player = $".."
@onready var label = $Label


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		player.health -= 10
#	label.text = str(player.jumping)
