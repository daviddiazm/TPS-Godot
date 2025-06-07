extends Node3D

@export var character : CharacterBody3D

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
		
func camera_look(mouse_movement: Vector2) -> void:
	camera_rotation += mouse_movement
	reset_rotation()
	#character.transform.basis = Basis()
	camera_rotation.y = clamp(camera_rotation.y, -max_y_rotation, max_y_rotation)
	print(camera_rotation.y)
	character.rotate_object_local(Vector3(0,1,0), -camera_rotation.x * camera_sensitivity)
	rotate_object_local(Vector3(1,0,0), -camera_rotation.y * camera_sensitivity)

	
	
func reset_rotation() -> void:
	var current_scale = transform.basis.get_scale()
	var new_basis = Basis()
	new_basis.scaled(current_scale)
	transform.basis = new_basis
