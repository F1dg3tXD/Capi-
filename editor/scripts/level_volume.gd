extends Node3D

enum TriggerMode { AUTO, PRESS, HOLD }

@export var scene_to_load: PackedScene
@export var trigger_mode: TriggerMode = TriggerMode.AUTO
@export var hold_duration: float = 1.5

## XR input action name, copy-paste from open_xr_action_map.tres
@export var input_action: String = "primary_click"

@onready var area: Area3D = $Area3D

var player_in_area: Node3D = null
var hold_timer: float = 0.0
var triggered: bool = false

func _ready():
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(delta):
	if triggered or not player_in_area:
		hold_timer = 0.0
		return

	match trigger_mode:
		TriggerMode.AUTO:
			load_target_scene()

		TriggerMode.PRESS:
			if Input.is_action_just_pressed(input_action):
				load_target_scene()

		TriggerMode.HOLD:
			if Input.is_action_pressed(input_action):
				hold_timer += delta
				if hold_timer >= hold_duration:
					load_target_scene()
			else:
				hold_timer = 0.0

func _on_body_entered(body):
	if body.collision_layer & (1 << 19):  # Layer 20 is index 19
		player_in_area = body

func _on_body_exited(body):
	if body == player_in_area:
		player_in_area = null
		hold_timer = 0.0

func load_target_scene():
	if triggered or not scene_to_load:
		return
	triggered = true
	get_tree().change_scene_to_packed(scene_to_load)
