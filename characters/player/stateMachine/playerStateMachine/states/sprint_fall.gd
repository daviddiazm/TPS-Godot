extends Motion

func _enter_tree() -> void:
	print(name)

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(SPRINT_SPEED, direction, _delta)
	calculate_graivty(_delta)
	if is_on_floor():
		if Input.is_action_pressed("sprint"):
			finish.emit("Sprint")
		elif direction != Vector3.ZERO:
			finish.emit("Run")
		else:
			finish.emit("Idle")
