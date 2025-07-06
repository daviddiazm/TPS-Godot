extends State
class_name Motion

signal velocity_updated(velocityFromMotion: Vector3)
signal animation_state_change(state: String)

var speed : float
var sprint_speed: float
var aim_speed: float
var jump_velocity: float
var jump_gravity: float
var fall_gravity: float


#const SPEED = 5.0
#const JUMP_VELOCITY = 4.5
#const AIM_SPEED: float = 2.0
#const ACCELERATION: float = 30
#const SPRINT_SPEED: float = 8
#const GRAVITY: float = -8.9
#const SPRINT_DURATION: float = 3.0

static var input_dir: Vector2 = Vector2.ZERO
static var direction: Vector3 = Vector3.ZERO
static var velocity:  Vector3 = Vector3.ZERO
static var sprint_remaining: float = 0.0

const PALYER_MOVEMENT_STATS = preload("res://characters/player/palyer_movement_stats.tres")

func _ready() -> void:
	velocity_updated.connect(owner.set_velocity_from_motion)
	sprint_remaining = PALYER_MOVEMENT_STATS.sprint_duration
	
	speed = PALYER_MOVEMENT_STATS.get_velocity(
		PALYER_MOVEMENT_STATS.jump_distance, 
		PALYER_MOVEMENT_STATS.time_to_jump_apex + PALYER_MOVEMENT_STATS.time_to_land
	)
	sprint_speed = PALYER_MOVEMENT_STATS.get_velocity(
		PALYER_MOVEMENT_STATS.sprint_jump_distance, 
		PALYER_MOVEMENT_STATS.time_to_jump_apex + PALYER_MOVEMENT_STATS.time_to_land
	)
	aim_speed = PALYER_MOVEMENT_STATS.get_velocity(
		PALYER_MOVEMENT_STATS.aim_jump_distance,
		PALYER_MOVEMENT_STATS.time_to_jump_apex + PALYER_MOVEMENT_STATS.time_to_land
	)
	jump_gravity = PALYER_MOVEMENT_STATS.get_jump_gravity()
	fall_gravity = PALYER_MOVEMENT_STATS.get_fall_gravity()
	jump_velocity = PALYER_MOVEMENT_STATS.get_jump_velocity(jump_gravity)
	print("jump gravity ", jump_gravity)
	print("fall gravity ", fall_gravity)
	print("jump velocity ", jump_velocity)
	print("speed ", speed)

func set_direction() -> void:
	input_dir = Input.get_vector("move_left", "move_right", "forward", "backward")
	direction = (owner.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func calculate_velocity(_speed: float, _direction: Vector3, acceleration,_delta: float) -> void:
	velocity.x = move_toward(velocity.x, _direction.x * _speed, acceleration * _delta)
	velocity.z = move_toward(velocity.z, _direction.z * _speed, acceleration * _delta)
	velocity_updated.emit(velocity)

func calculate_graivty(_delta: float) -> void:
	if not owner.is_on_floor():
		if velocity.y > 0:
			velocity.y -= jump_gravity * _delta
		else:
			velocity.y -= fall_gravity * _delta

func is_on_floor() -> bool:
	return owner.is_on_floor()

func replenish_sprint(_delta: float):
	sprint_remaining = min(sprint_remaining + _delta, PALYER_MOVEMENT_STATS.sprint_duration)
