extends Node3D

@export var uses_gamepad: bool = false

@export var camera_traget: Node3D
@export var pitch_max: float = 50.00
@export var pitch_min: float = -50.00

#actions names
@export var CAMERA_RIGHT: String = "camera_right"
@export var CAMERA_LEFT: String = "camera_left"
@export var CAMERA_UP: String = "camera_up"
@export var CAMERA_DOWN: String = "camera_down"

var yaw = float()
var pitch = float()
var yaw_sensitivity = 0.002
var pitch_sensitivity = 0.002

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() != 0:
		yaw += - event.relative.x * yaw_sensitivity
		pitch += - event.relative.y * pitch_sensitivity

func _physics_process(delta):
	camera_traget.rotation.y = lerpf(camera_traget.rotation.y, yaw, delta * 10)
	camera_traget.rotation.x = lerpf(camera_traget.rotation.x, pitch, delta * 10)

	pitch = clamp(pitch, deg_to_rad(pitch_min), deg_to_rad(pitch_max))

	#gamepad settings
	if uses_gamepad:
		var camera_input_x = Input.get_axis(CAMERA_RIGHT, CAMERA_LEFT)
		var camera_input_y = Input.get_axis(CAMERA_DOWN, CAMERA_UP)
		var camera_input = Vector2(camera_input_x, camera_input_y)

		yaw += camera_input.x * yaw_sensitivity * 30
		pitch += camera_input.y * pitch_sensitivity * 20
