extends Node

@onready var enter_vr_button: Button = $CanvasLayer/Control/Button

func _ready():
	# Only show VR button if WebXR is available
	var webxr = XRServer.find_interface("WebXR")
	if webxr and webxr.is_initialized():
		enter_vr_button.visible = true
	else:
		enter_vr_button.visible = false

	enter_vr_button.pressed.connect(_on_enter_vr_pressed)

func _on_enter_vr_pressed():
	var webxr = XRServer.find_interface("WebXR")
	if webxr and webxr.is_initialized():
		print("Requesting WebXR session...")
		XRServer.set_primary_interface(webxr)
		get_viewport().use_xr = true
		webxr.enter_vr()
	else:
		print("WebXR not initialized or not available.")
