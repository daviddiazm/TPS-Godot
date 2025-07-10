extends Motion

@export var floor_ray_cast : RayCast3D

func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(speed, direction, PALYER_MOVEMENT_STATS.in_air_acceleration ,_delta)
	calculate_graivty(_delta)
	
	if floor_ray_cast.is_colliding():
		if direction != Vector3.ZERO:
			animation_state_change.emit("Run")
	
	if is_on_floor():
		if direction != Vector3.ZERO:
			finish.emit("Sprint")
		else:
			finish.emit("Idle")
