extends Motion

signal aim_entered
signal aim_exited

func _enter() -> void:
	aim_entered.emit()
	return super._enter()
	
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		aim_exited.emit()
		finish.emit("Jump")
		
	if _event.is_action_pressed("sprint") and sprint_remaining > 0.5 :
		aim_exited.emit()
		finish.emit("Sprint")
		
	if _event.is_action_released("aim"):
		aim_exited.emit()
		finish.emit("Run")

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(aim_speed, direction, PALYER_MOVEMENT_STATS.acceleration, _delta)
	replenish_sprint(_delta)
	
	if direction == Vector3.ZERO:
		aim_exited.emit()
		finish.emit("AimWalk")
	
	if not is_on_floor():
		aim_exited.emit()
		finish.emit("Fall")
	input_direction_change.emit(input_dir)
