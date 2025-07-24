extends Node3D

@onready var debug_visuals: Node = $debug

func _ready():
	debug_draw(false)

	if Engine.is_editor_hint():
		return

	# Access the global Player scene from the Globals singleton
	var player_scene: PackedScene = get_node("/root/Globals").Player
	if player_scene == null:
		push_error("Globals.PlayerScene is null. Make sure it's assigned in the Globals autoload.")
		return

	var player_instance = player_scene.instantiate()
	get_tree().current_scene.add_child(player_instance)
	player_instance.global_transform = global_transform

func debug_draw(enabled: bool = true) -> void:
	if debug_visuals and debug_visuals.is_valid():
		debug_visuals.visible = enabled

func _enter_tree():
	if Engine.is_editor_hint():
		debug_draw(true)

func _exit_tree():
	if Engine.is_editor_hint():
		debug_draw(false)
