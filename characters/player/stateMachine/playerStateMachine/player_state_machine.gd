extends StateMachine

@export var movement_stats_player: MovementStats
@export var character_model: CharacterModel

func _ready() -> void:
	print("Character model is: ", character_model)
	for child:Motion in get_children():
		child.animation_state_change.connect(character_model.on_state_machine_animation_state_change)
		child.input_direction_change.connect(character_model.on_input_direction_changed)
	return super._ready()
