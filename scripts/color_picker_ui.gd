extends Control

@export var target_character: Node3D
@onready var color0_picker_button: ColorPickerButton = $HBoxContainer/Color0/ColorPickerButton
@onready var color1_picker_button: ColorPickerButton = $HBoxContainer/Color1/ColorPickerButton
@onready var color2_picker_button: ColorPickerButton = $HBoxContainer/Color3/ColorPickerButton


func _ready():
	color0_picker_button.color_changed.connect(_on_skin_color_changed)
	color1_picker_button.color_changed.connect(_on_shirt_color_changed)
	color2_picker_button.color_changed.connect(_on_pants_color_changed)

func _on_skin_color_changed(color: Color):
	_set_material_color(0, color)

func _on_shirt_color_changed(color: Color):
	_set_material_color(1, color)

func _on_pants_color_changed(color: Color):
	_set_material_color(3, color)

func _set_material_color(slot: int, color: Color):
	if not target_character:
		return

	var mesh = target_character.get_node("MeshInstance3D")
	if not mesh:
		return

	var mat = mesh.get_surface_override_material(slot)
	if not mat:
		# fallback to instance material if override isn't set
		mat = mesh.material_override
		if not mat:
			return

	# Duplicate material if shared
	if mat.is_shared():
		mat = mat.duplicate()
		mesh.set_surface_override_material(slot, mat)

	mat.albedo_color = color
