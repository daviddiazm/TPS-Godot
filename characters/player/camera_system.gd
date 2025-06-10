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

@onready var default_spring_arm_edge_length :float = edge_spring_arm.spring_length
@onready var default_spring_arm_rear_length :float = rear_spring_arm.spring_length
@onready var default_camera_fov :float = camera.fov

var camera_tween: Tween
var camera_rotation: Vector2 = Vector2.ZERO
var camera_sensitivity: float = 0.002
var max_y_rotation: int = 180

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
	
func camera_look(mouse_movement: Vector2) -> void:
	camera_rotation += mouse_movement
	reset_rotation()
	character.transform.basis = Basis()
	camera_rotation.y = clamp(camera_rotation.y, -max_y_rotation, max_y_rotation+180)
	character.rotate_object_local(Vector3(0,1,0), -camera_rotation.x * camera_sensitivity)
	rotate_object_local(Vector3(1,0,0), -camera_rotation.y * camera_sensitivity)

func swap_camera_alignment() -> void:
	default_spring_arm_edge_length = -default_spring_arm_edge_length
	#var new_pos: float = default_spring_arm_edge_length * -sign(edge_spring_arm.spring_length)
	set_spring_arm_postition(default_spring_arm_edge_length, transition_speed_camera_swap)
	
func set_spring_arm_postition(pos: float, speed: float) -> void:
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.tween_property(edge_spring_arm, "spring_length", pos, speed)
	
func reset_rotation() -> void:
	var current_scale = transform.basis.get_scale()
	var new_basis = Basis()
	new_basis.scaled(current_scale)
	transform.basis = new_basis

func enter_aim():
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel(true)
	camera_tween.tween_property(camera, "fov", camera_fov_aim, aim_speed)
	camera_tween.tween_property(
		edge_spring_arm, 
		"spring_length", 
		aim_edge_spring_length * sign(edge_spring_arm.spring_length), 
		aim_speed)
	camera_tween.tween_property(
		rear_spring_arm , 
		"spring_length", 
		aim_rear_spring_length, 
		aim_speed)

func exit_aim():
	if camera_tween:
		camera_tween.kill()
	camera_tween = get_tree().create_tween()
	camera_tween.set_parallel(true)
	camera_tween.tween_property(camera, "fov", default_camera_fov, aim_speed)
	camera_tween.tween_property(
		edge_spring_arm, 
		"spring_length", 
		default_spring_arm_edge_length  * sign(edge_spring_arm.spring_length), 
		aim_speed)
	camera_tween.tween_property(
		rear_spring_arm , 
		"spring_length", 
		default_spring_arm_rear_length, 
		aim_speed)
