class_name EnemyHitDetection
extends Area2D
enum TYPE {DEFAULT}
@export var type : TYPE = TYPE.DEFAULT
signal take_damage(dmg)

func _ready():
	connect("body_entered", handle_player_body)
	connect("area_entered", handle_area)

func handle_player_body(body):
	if not body is Player:
		return
	var player : Player = body
	match type:
		TYPE.DEFAULT: type_default(player)

func handle_area(area):
	if area.is_in_group("slide"):
		emit_signal("take_damage", 100)

func type_default(player : Player):
	var fall_boast = 0
	if player.velocity.y > 700:
		fall_boast = player.velocity.y / 1500 * 70
	emit_signal("take_damage", 10 + fall_boast)
	if player.state_helper.states.has("slide"):
		return
	player.velocity.y = player.JUMP_VELOCITY
	player.state_helper.reset("air")
	player.is_doward = false
