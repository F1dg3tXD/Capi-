@tool
extends Node3D
class_name XRMapLoader

@export_file("*.tscn") var map_to_load: String
@export var load_button_action: String = "primary_click"

var _button_was_pressed: bool = false

# Get controller at runtime
@onready var _controller: XRController3D = XRHelpers.get_xr_controller(self)

func _physics_process(_delta: float) -> void:
	if _controller == null or map_to_load.is_empty() or load_button_action.is_empty():
		return

	var button_down := _controller.is_button_pressed(load_button_action)
	var button_pressed := button_down and !_button_was_pressed
	_button_was_pressed = button_down

	if button_pressed:
		print("🎮 XR Button '%s' pressed. Loading map..." % load_button_action)
		call_deferred("_load_map")

func _load_map():
	get_tree().change_scene_to_file(map_to_load)
