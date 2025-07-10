extends Motion

func _enter() -> void:
	jump()
	return super._enter()

func _update(_delta: float) -> void:
	set_direction()
	calculate_graivty(_delta)
	calculate_velocity(speed, direction, PALYER_MOVEMENT_STATS.in_air_acceleration ,_delta)
	if velocity.y <= 0:
		finish.emit("Fall")
	
func jump() -> void:
	velocity.y = jump_velocity
	
