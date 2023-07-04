extends Area2D

func can_stand():
	print(get_overlapping_bodies())
	if get_overlapping_bodies().size() > 0:
		return false
	return true
