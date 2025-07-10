extends Motion

func _enter() -> void:
	jump()
	return super._enter()

func _update(_delta: float) -> void:
	#set_direction()
	calculate_graivty(_delta)
	calculate_velocity(sprint_speed, direction, PALYER_MOVEMENT_STATS.in_air_acceleration, _delta)
	sprint_remaining -= _delta
	input_direction_change.emit(input_dir)

	if velocity.y <= 0:
		finish.emit("SprintFall")
	
func jump() -> void:
	velocity.y = jump_velocity
