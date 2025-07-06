extends Motion

func _enter() -> void:
	print(name)
	animation_state_change.emit("jump")


func _update(_delta: float) -> void:
	set_direction()
	calculate_velocity(speed, direction, PALYER_MOVEMENT_STATS.in_air_acceleration ,_delta)
	calculate_graivty(_delta)
	if is_on_floor():
		finish.emit("Idle")
