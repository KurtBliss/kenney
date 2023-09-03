extends Area2D

func can_stand():
	if get_overlapping_bodies().size() > 0:
		return false
	return true
