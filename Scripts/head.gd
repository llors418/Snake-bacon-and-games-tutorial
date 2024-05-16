class_name Head extends SnakePart

signal coin_pick
signal collided_with_tail

func _on_area_entered(area):
	if area.is_in_group("coins"):
		# we collided with food
		coin_pick.emit()
		area.call_deferred("queue_free")
	else:
		collided_with_tail.emit()
		pass # R	eplace with function body.
