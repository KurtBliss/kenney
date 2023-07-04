extends ProgressBar

@onready var player : Player = $"../.."

func _process(delta):
	value = player.health
