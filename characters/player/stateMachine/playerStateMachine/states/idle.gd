extends Motion
	
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finish.emit("Jump")
	
	if _event.is_action_pressed("sprint") and sprint_remaining > 0.5 :
		finish.emit("Sprint")
	
	if _event.is_action_pressed("aim"):
		finish.emit("AimIdle")

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(speed, direction, PALYER_MOVEMENT_STATS.acceleration,_delta)
	replenish_sprint(_delta)
	
	if direction != Vector3.ZERO :
		finish.emit("Run")
	
	if not is_on_floor():
		finish.emit("Fall")
