extends Node
signal spike_collision(dmg, speed)
@onready var player : Player = $".."
@onready var feet_marker = $"../FeetMarker"
var previous_landed = false
@export_exp_easing("inout") var curve

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var tm : TileMap = ref.tilemap
	if not is_instance_valid(tm):
		return
	
	var landed = get_tile_spike(tm, feet_marker.global_position)
	if !previous_landed and landed and player.velocity.y > 0:
		var dmg : float = abs(player.velocity.y / 700)
		dmg = ease(dmg, curve)
		var spd = 1
		if dmg > 0.01:
			emit_signal("spike_collision", dmg * 70, spd)
			
	previous_landed = landed

func get_tile_spike(tile_map : TileMap, position):
	var clicked_cell = tile_map.local_to_map(position)
	var data = tile_map.get_cell_tile_data(0, clicked_cell)
	if data:
		return data.get_custom_data("spike")
	else:
		return false
