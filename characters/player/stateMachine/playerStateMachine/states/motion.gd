extends State
class_name Motion

signal velocity_updated(velocityFromMotion: Vector3)

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const ACCELERATION: float = 30
const SPRINT_SPEED: float = 8
const GRAVITY: float = -8.9

static var input_dir: Vector2 = Vector2.ZERO
static var direction: Vector3 = Vector3.ZERO
static var velocity:  Vector3 = Vector3.ZERO

func _ready() -> void:
	velocity_updated.connect(owner.set_velocity_from_motion)

func set_direction() -> void:
	input_dir = Input.get_vector("move_left", "move_right", "forward", "backward")
	direction = (owner.global_transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

func calculate_velocity(_speed: float, _direction: Vector3, _delta: float) -> void:
	velocity.x = move_toward(velocity.x, _direction.x * _speed, ACCELERATION * _delta)
	velocity.z = move_toward(velocity.z, _direction.z * _speed, ACCELERATION * _delta)
	velocity_updated.emit(velocity)

func calculate_graivty(_delta: float) -> void:
	if not owner.is_on_floor():
		velocity.y += GRAVITY * _delta

func is_on_floor() -> bool:
	return owner.is_on_floor()
