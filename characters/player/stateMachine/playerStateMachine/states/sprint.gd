extends Motion

func _enter_tree() -> void:
	print(name)

func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finish.emit("SprintJump")

	if _event.is_action_released("sprint"):
		finish.emit("SprintFall")
	
	


func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(SPRINT_SPEED, direction, _delta)
	
	if direction == Vector3.ZERO:
		finish.emit("Idle")
		
	if not is_on_floor():
		finish.emit("Fall")
