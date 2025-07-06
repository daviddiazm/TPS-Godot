extends Node3D
class_name CharacterModel

@export var animation_tree: AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func on_state_machine_animation_state_change(state: String) -> void:
	print("desde el Character model ", state)
	print("el animation tree ",animation_tree)
	animation_tree["parameters/unarmed_movenmnent/transition_request"] = state
	#animation_tree["parameters/state/transition_request"] = state
	#animation_tree["parameters/unarmed_movement/transition_request"] = state
