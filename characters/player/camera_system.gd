extends Node3D

@export var character : CharacterBody3D
@export var edge_spring_arm: SpringArm3D
@export var rear_spring_arm: SpringArm3D
@export var camera: Camera3D 
@export var transition_speed_camera_swap: float = 0.2
@export var aim_edge_spring_length: float = 0.5
@export var aim_rear_spring_length: float = 0.5
@export var aim_speed: float = 0.2
@export var camera_fov_aim: float = 55
@export var sprint_fov: float = 90
@export var spirnt_speed_fov: float = 0.5

@onready var default_spring_arm_edge_length :float = edge_spring_arm.spring_length
@onready var default_spring_arm_rear_length :float = rear_spring_arm.spring_length
@onready var default_camera_fov :float = camera.fov

var camera_tween: Tween
var camera_rotation: Vector2 = Vector2.ZERO
var camera_sensitivity: float = 0.002
var max_y_rotation: int = 180
enum CameraAlignment {RIGHT = 1, LEFT = -1, CENTER = 0}
var current_camera_alignment = CameraAlignment.RIGHT

var camera_side := 1 # 1 = derecha, -1 = izquierda


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else :
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	if event is InputEventMouseMotion:
		var mouse_event: Vector2 = event.relative
		camera_look(mouse_event)
	if event.is_action_pressed("swap_camera"):
		swap_camera_alignment()
	if event.is_action_pressed("aim"):
		enter_aim()
	if event.is_action_released("aim"):
		exit_aim()
	if event.is_action_pressed("sprint"):
		enter_spirnt()
	if event.is_action_released("sprint"):
		exit_sprint()
	
func camera_look(mouse_movement: Vector2) -> void:
	camera_rotation += mouse_movement
	reset_rotation()
	character.transform.basis = Basis()
	camera_rotation.y = clamp(camera_rotation.y, -max_y_rotation, max_y_rotation+180)
	character.rotate_object_local(Vector3(0,1,0), -camera_rotation.x * camera_sensitivity)
	rotate_object_local(Vector3(1,0,0), -camera_rotation.y * camera_sensitivity)

func change_camera_alignment(alignment: CameraAlignment ) -> void:
	current_camera_alignment = alignment

func swap_camera_alignment() -> void:
	camera_side *= -1
	match current_camera_alignment:
		CameraAlignment.RIGHT:
			change_camera_alignment(CameraAlignment.LEFT)
		CameraAlignment.LEFT:
			change_camera_alignment(CameraAlignment.RIGHT)
		#CameraAlignment.CENTER:
			#change_camera_alignment(CameraAlignment.CENTER)
	var new_pos = default_spring_arm_edge_length * current_camera_alignment
	set_spring_arm_postition(new_pos, transition_speed_camera_swap)
	
	
func set_spring_arm_postition(pos: float, speed: float) -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.tween_property(edge_spring_arm, "spring_length", pos, speed)
	
func reset_rotation() -> void:
	var current_scale = transform.basis.get_scale()
	var new_basis = Basis()
	new_basis.scaled(current_scale)
	transform.basis = new_basis

func enter_aim() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	#camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.set_parallel(true)
	camera_tween.tween_property(camera, "fov", camera_fov_aim, aim_speed)
	camera_tween.tween_property(
		edge_spring_arm, 
		"spring_length", 
		aim_edge_spring_length * current_camera_alignment, 
		aim_speed)
	camera_tween.tween_property(
		rear_spring_arm , 
		"spring_length", 
		aim_rear_spring_length, 
		aim_speed)

func exit_aim() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_IN)
	camera_tween.set_parallel(true)
	camera_tween.tween_property(camera, "fov", default_camera_fov, aim_speed)
	camera_tween.tween_property(
		edge_spring_arm, 
		"spring_length", 
		default_spring_arm_edge_length  * current_camera_alignment, 
		aim_speed)
	camera_tween.tween_property(
		rear_spring_arm , 
		"spring_length", 
		default_spring_arm_rear_length, 
		aim_speed)


func enter_spirnt() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_IN_OUT)
	camera_tween.tween_property(camera, "fov", sprint_fov, spirnt_speed_fov)
	camera_tween.tween_property(
		edge_spring_arm, 
		"spring_length", 
		default_spring_arm_edge_length  * current_camera_alignment, 
		aim_speed)
	camera_tween.tween_property(
		rear_spring_arm , 
		"spring_length", 
		default_spring_arm_rear_length, 
		aim_speed)


func exit_sprint() -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel()
	camera_tween.set_trans(Tween.TRANS_EXPO)
	camera_tween.set_ease(Tween.EASE_OUT)
	camera_tween.tween_property(camera, "fov", default_camera_fov, spirnt_speed_fov)
	camera_tween.tween_property(
		edge_spring_arm, 
		"spring_length", 
		default_spring_arm_edge_length  * current_camera_alignment, 
		aim_speed)
	camera_tween.tween_property(
		rear_spring_arm , 
		"spring_length", 
		default_spring_arm_rear_length, 
		aim_speed)
