extends Node3D
class_name CharacterModel

@export var animation_tree: AnimationTree
@export var armature: Node3D
@export var turn_rate: float = 0.1

var current_mouse_rotation: Vector2
var input_dir: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_camera_system_mouse_rotated(Vector2(0,-1))
	on_input_direction_changed(Vector2(0,-1))


func on_state_machine_animation_state_change(state: String) -> void:
	animation_tree["parameters/unarmed_movenmnent/transition_request"] = state

func _on_camera_system_mouse_rotated(_rotation: Vector2) -> void:
	current_mouse_rotation = _rotation
	transform.basis = Basis()
	rotate_object_local(Vector3(0,1,0), current_mouse_rotation.x )

func on_input_direction_changed(_input_direction: Vector2 ) -> void:
	#print("_input_direction ", _input_direction)
	input_dir = input_dir.lerp(_input_direction,turn_rate)
	#print("input_dir ",input_dir)
	rotate_armature(input_dir, current_mouse_rotation.x)

func rotate_armature(angle: Vector2, _offset: float = 0) -> void:
	var new_angle: float = atan2(angle.x, angle.y) - _offset
	#print("angle ",angle)
	#print("new angle ",new_angle)
	#print("_offset ",_offset)
	#print(" ")
	armature.basis = Basis()
	armature.rotate_object_local(Vector3(0,1,0), new_angle)
	
	
	
	
	
	
	
	
