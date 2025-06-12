extends Motion

func _enter_tree() -> void:
	print(name)

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(SPEED, direction, _delta)
	calculate_graivty(_delta)
	if is_on_floor():
		finish.emit("Idle")
