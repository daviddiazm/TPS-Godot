extends Motion

signal sprint_ended

@export var floor_ray_cast : RayCast3D

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(sprint_speed, direction, PALYER_MOVEMENT_STATS.in_air_acceleration, _delta)
	calculate_graivty(_delta)
	sprint_remaining -= _delta
	
	if floor_ray_cast.is_colliding() and direction != Vector3.ZERO:
		animation_state_change.emit("Run")
	
	if is_on_floor():
		if Input.is_action_pressed("sprint"):
			finish.emit("Sprint")
		elif direction != Vector3.ZERO:
			finish.emit("Run")
			sprint_ended.emit()
		else:
			finish.emit("Idle")
			sprint_ended.emit()
	input_direction_change.emit(input_dir)
