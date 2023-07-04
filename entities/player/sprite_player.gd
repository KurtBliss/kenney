extends AnimationPlayer
@onready var state_helper = $"../StateHelper"
@onready var sprite = $"../AnimatedSprite2D"
@onready var player : Player = $".."
# ?todo: delta based frame rate

### Built In Functions
func _process(delta): 
	state_helper.process(self, delta) 

### States
func process_ground(delta):
	reset_duck()
	sprite.flip_v = false
	if player.velocity.x != 0:
		sprite.flip_h = player.velocity.x < 0
		sprite.play("walk", player.get_speed() / player.SPEED * delta * 60)
	else:
		sprite.play("idle", delta * 60)

func process_air(delta):
	reset_duck()
	sprite.flip_v = false	
	if player.velocity.x != 0:
		sprite.flip_h = player.velocity.x < 0
	sprite.play("jump", delta * 60)

func process_downward(delta):
	reset_duck()
	sprite.flip_v = true
	if player.velocity.x != 0:
		sprite.flip_h = player.velocity.x < 0
	sprite.play("jump", delta * 60)

func process_duck(delta):
#	if player.velocity.x != 0:
#		play("ball")
#		sprite.rotate(deg_to_rad(player.velocity.x / player.ROLL * 45))
#	elif abs(player.velocity.x) < 100:
	play("duck")
	sprite.flip_v = false
	

func reset_duck():
	if (current_animation == "duck" or current_animation == "ball") \
	and not state_helper.states.has("duck"):
		play("RESET")

#func _on_animation_finished(anim_name):
#	if anim_name == "duck":
#		play("RESET")
