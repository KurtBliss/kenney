extends Area2D
@onready var player = $".."
@onready var animation_player = $"../AnimationPlayerHurt"
var test_area : Area2D
var test_damage : float = 0.0
@onready var timer = $Timer

func take_damage(dmg, speed = 1):
	if animation_player.current_animation != "hurt":
		player.health -= dmg
		animation_player.play("hurt", -1, speed)

func _on_area_entered(area):
	if area.is_in_group("fireball"):
		take_damage(15, 1.5)
	elif area.is_in_group("enemy_damage"):
		take_damage(25)

func _on_spike_collision_spike_collision(dmg, speed):
	take_damage(dmg, speed)
