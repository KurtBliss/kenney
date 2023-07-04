extends Camera2D
@onready var player = $".."
@onready var starting_zoom = zoom

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		return
	
	if is_instance_valid(player) and not player is Player:
		return
	
	var high_top = 648 * 5.5
	var high_cur = player.position.y - player.jump_start
	
	if player.jumping and high_cur:
		var multi = high_cur / high_top / 2
		multi = max(multi, -0.15)
		zoom = zoom.lerp(Vector2(starting_zoom.x + multi, starting_zoom.y + multi), 1)
	zoom = zoom.lerp(starting_zoom, 0.1)

