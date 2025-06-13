extends Motion

func _enter() -> void:
	print(name)
	
func _state_input(_event: InputEvent) -> void:
	if _event.is_action_pressed("jump"):
		finish.emit("Jump")

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(SPEED, direction, _delta)
	replenish_sprint(_delta)
	
	#if direction != Vector3.ZERO:
		#finish.emit("Run")
	
	if direction != Vector3.ZERO && Input.is_action_pressed("forward") || Input.is_action_pressed("backward") || Input.is_action_pressed("move_left") || Input.is_action_pressed("move_right"):
		finish.emit("Run")
	
	if not is_on_floor():
		finish.emit("Fall")
