extends Camera2D
@onready var player = $".."
@onready var starting_zoom = zoom

var last_ground_position := 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player == null:
		return
	
	if is_instance_valid(player) and not player is Player:
		return
	
	if player.is_on_floor():
		last_ground_position = player.position.y
	
	var high_top = 648 * 3
	var high_cur = player.position.y - last_ground_position #- player.jump_start
	
#	if player.jumping and high_cur:
	if (not player.position.y > last_ground_position) and high_cur:
		var multi = high_cur / high_top / 1.2
		multi = max(multi, -0.15)
		# ? delta or delta * 60
		zoom = zoom.lerp(Vector2(starting_zoom.x + multi, starting_zoom.y + multi), 1)
	zoom = zoom.lerp(starting_zoom, 0.1)

