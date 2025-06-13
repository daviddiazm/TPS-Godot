extends Motion

func _enter() -> void:
	print(name)
	jump()

func _update(_delta: float) -> void:
	set_direction()
	calculate_graivty(_delta)
	calculate_velocity(SPEED, direction, _delta)
	if velocity.y <= 0:
		finish.emit("Fall")
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY
	
