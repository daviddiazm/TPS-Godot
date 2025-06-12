extends Motion

func _enter_tree() -> void:
	print(name)
	jump()

func _update(_delta: float) -> void:
	#set_direction()
	calculate_graivty(_delta)
	calculate_velocity(SPRINT_SPEED, direction, _delta)
	if velocity.y <= 0:
		finish.emit("SprintFall")
	
func jump() -> void:
	velocity.y = JUMP_VELOCITY
