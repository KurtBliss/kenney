extends Marker2D

@onready var super_fly = $".."
var ld_fireball = preload("res://entities/enemies/fly/fireball.tscn")

func _on_timer_timeout():
	if super_fly.state == super_fly.STATE_FLY \
	and is_instance_valid(ref.player):
		var fireball = ld_fireball.instantiate()
		var vect_to_player = ref.player.global_position-global_position
		vect_to_player = vect_to_player.normalized()
		ref.level.add_child(fireball)
		if vect_to_player.x < 0:
			fireball.multiply = -1
		fireball.direction = vect_to_player
		fireball.global_position = global_position
