extends Node
class_name StateMachine

@export var start_state: State
var state_map: Dictionary
var current_state: State = null
var active: bool = false :
	set = set_active

func _ready() -> void:
	initialize(start_state)

func _input(event: InputEvent) -> void:
	current_state._state_input(event)

func initialize(state: State) -> void:
	set_active(true)
	create_state_map()
	current_state = state
	current_state._enter_tree()

func _physics_process(delta: float) -> void:
	current_state._update(delta)

func create_state_map() -> void:
	for child: State in get_children():
		child.finish.connect(change_state)
		state_map[child.name] = child

func set_active(value: bool) -> void:
	active = value
	set_physics_process(active)
	set_process_input(active)
	if not active:
		current_state = null

func change_state(state_name: String) -> void:
	if not active:
		return
	current_state._exit_tree()
	current_state = state_map[state_name]
	current_state._enter_tree()
