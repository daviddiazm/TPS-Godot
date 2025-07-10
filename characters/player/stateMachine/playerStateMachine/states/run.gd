extends Motion

func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finish.emit("Jump")
	
	if _event.is_action_pressed("sprint") and sprint_remaining > PALYER_MOVEMENT_STATS.minimum_sprint_threshold :
		finish.emit("Sprint")
	
	if _event.is_action_pressed("aim"):
		finish.emit("AimWalk")

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(speed, direction, PALYER_MOVEMENT_STATS.acceleration ,_delta)
	replenish_sprint(_delta)
	
	if direction == Vector3.ZERO:
		finish.emit("Idle")
		
	if not is_on_floor():
		finish.emit("Fall")
	input_direction_change.emit(input_dir)
