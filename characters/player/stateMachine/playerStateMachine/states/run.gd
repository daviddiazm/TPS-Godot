extends Motion

func _enter() -> void:
	print(name)

func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finish.emit("Jump")
	
	if _event.is_action_pressed("sprint") and sprint_remaining > 0.5 :
		finish.emit("Sprint")

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(SPEED, direction, _delta)
	replenish_sprint(_delta)
	
	if direction == Vector3.ZERO:
		finish.emit("Idle")
		
	if not is_on_floor():
		finish.emit("Fall")
