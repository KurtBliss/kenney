extends Area2D
@onready var player = $".."
@onready var modulate_player = $"../ModulatePlayer"
var test_area : Area2D
var test_damage : float = 0.0
@onready var timer = $Timer
@onready var state_helper = $"../StateHelper"

func take_damage(dmg, speed = 1):
	if modulate_player.current_animation != "hurt":
		player.health -= dmg
		modulate_player.play("hurt", -1, speed)

func _on_area_entered(area):
	if area.is_in_group("fireball"):
		take_damage(15, 1.5)
	elif area.is_in_group("enemy_damage") \
	and not state_helper.states.has("slide"):
		take_damage(25)
	elif area.is_in_group("poop"):
		take_damage(25)

func _on_spike_collision_spike_collision(dmg, speed):
	take_damage(dmg, speed)
