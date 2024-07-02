extends CharacterBody3D

@export var animation_tree: AnimationTree
@export var animation_player: AnimationPlayer

#action names
@export var MOVE_LEFT: String = "move_left"
@export var MOVE_RIGHT: String = "move_right"
@export var MOVE_FORWARD: String = "move_forward"
@export var MOVE_BACKWARD: String = "move_backward"

@onready var animation_state = animation_tree.get("parameters/playback")

var input_dir = Vector3.ZERO

var anim_can_move = bool()
var is_running = bool()
var is_moving_backwards = bool()

var direction = Vector3.ZERO
var vertical_velocity = Vector3.ZERO
var turn_speed = 10
var root_velocity = Vector3.ZERO

var horizontal = float()
var vertical = float()

func _process(delta):
	horizontal = Input.get_axis(MOVE_RIGHT, MOVE_LEFT)
	vertical = Input.get_axis(MOVE_BACKWARD, MOVE_FORWARD)

	var root_position = animation_tree.get_root_motion_position()
	var current_rotation = (animation_tree.get_root_motion_rotation_accumulator().inverse() * get_quaternion())
	root_velocity = current_rotation * root_position / delta
	var root_rotation = animation_tree.get_root_motion_rotation()
	set_quaternion(root_rotation * get_quaternion())
	print("horizontal: ", horizontal)
	print("vertical: ", vertical)

func _physics_process(delta):
	animation_tree.set("parameters/conditions/startmove", is_running)
	animation_tree.set("parameters/conditions/backward", is_moving_backwards)
	animation_tree.set("parameters/conditions/idle", !is_running and !is_moving_backwards)

	#move input
	input_dir = Vector3(horizontal, 0, vertical).normalized()
	anim_can_move = input_dir != Vector3.ZERO
	
	if input_dir.z > 0:
		is_moving_backwards = false
		is_running = true
	elif input_dir.z < 0:
		is_running = false
		is_moving_backwards = true
	else: 
		is_moving_backwards = false
		is_running = false

	#rotation 
	# rotation.y = lerp_angle(rotation.y, atan2(direction.x, direction.z), turn_speed * delta)

	velocity = root_velocity
	move_and_slide()
