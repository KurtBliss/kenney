extends Marker2D
@onready var player : Player = $".."
var current_trail : Trail
var delay = 0

func _process(_delta):
	return
	
	if player.is_doward:
		if --delay <= 0:
			make_trail()
			delay = 5
	if player.is_on_floor():
		if current_trail:
			current_trail.stop()
			current_trail = null

func make_trail() -> void:
	if current_trail:
		current_trail.stop()
	current_trail = Trail.create()
	add_child(current_trail)

