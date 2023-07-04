extends AnimatedSprite2D
@export var downward := Color(0.74901962280273, 1, 1)
@onready var return_modulate := self_modulate


func _on_animation_changed():
	if animation == "downward":
		return_modulate = self_modulate
		self_modulate = downward
	else:
		self_modulate = return_modulate
