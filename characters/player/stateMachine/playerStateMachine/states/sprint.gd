extends Motion

signal sprint_started
signal sprint_ended

func _enter() -> void:
	sprint_started.emit()
	return super._enter()

func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finish.emit("SprintJump")

	if _event.is_action_released("sprint"):
		sprint_ended.emit()
		finish.emit("Run")


func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(sprint_speed, direction, PALYER_MOVEMENT_STATS.acceleration,_delta)
	
	sprint_remaining -= _delta
	if sprint_remaining <= 0:
		finish.emit("Run")
		sprint_ended.emit()
	
	if direction == Vector3.ZERO:
		sprint_ended.emit()
		finish.emit("Idle")
		
	if not is_on_floor():
		finish.emit("Fall")
	input_direction_change.emit(input_dir)
