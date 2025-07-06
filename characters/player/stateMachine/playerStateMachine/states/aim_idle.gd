extends Motion

signal aim_entered
signal aim_exited

func _enter() -> void:
	aim_entered.emit()
	animation_state_change.emit("Idle")
	print(name)
	
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		aim_exited.emit()
		finish.emit("Jump")
	if _event.is_action_released("aim"):
		aim_exited.emit()
		finish.emit("Idle")

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(aim_speed, direction, PALYER_MOVEMENT_STATS.acceleration,_delta)
	replenish_sprint(_delta)
	
	if direction != Vector3.ZERO:
		aim_exited.emit()
		finish.emit("AimWalk")
	
	if not is_on_floor():
		aim_exited.emit()
		finish.emit("Fall")
