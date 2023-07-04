class_name EnemyHealth
extends ProgressBar
@onready var enemy : Enemy = get_node("..")
signal hurt(dmg)
signal dead()

func _process(_delta):
	visible = value < max_value and value > min_value

func on_take_damage(dmg):
	value -= dmg
	if value <= min_value:
		emit_signal("dead")
	else:
		emit_signal("hurt", dmg)

func _on_hit_detection_take_damage(dmg):
	on_take_damage(dmg)
