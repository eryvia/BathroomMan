extends CharacterBody3D

@export var move_speed := 7.5
@export var accel := 18.0
@export var air_accel := 6.0
@export var friction := 22.0

@export var gravity := 24.0
@export var jump_height := 1.2

# Feel-good extras
@export var coyote_time := 0.12         # jump allowed shortly after leaving ground
@export var jump_buffer_time := 0.12    # jump pressed shortly before landing still works

@export var mouse_sens := 0.08

@onready var cam_pivot := $CamPivot
@onready var cam := $CamPivot/Camera3D

var _coyote_timer := 0.0
var _jump_buffer_timer := 0.0

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		# yaw (turn body left/right)
		rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		# pitch (look up/down)
		cam_pivot.rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		cam_pivot.rotation.x = clamp(cam_pivot.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(delta):
	# 1) --- Input as a 2D vector ---
	var input_2d := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	# input_2d length is <= 1 automatically (diagonal isn’t faster)

	# 2) --- Convert input to 3D direction, camera/body relative ---
	# Take the body's basis (or camera yaw basis), build ground-plane vectors.
	var forward := -global_transform.basis.z
	var right := global_transform.basis.x

	# Flatten so looking up/down doesn't affect movement
	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	# Direction on XZ plane
	var wish_dir := (right * input_2d.x + forward * input_2d.y)
	if wish_dir.length() > 0:
		wish_dir = wish_dir.normalized()

	# 3) --- Jump buffer + coyote time timers ---
	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer = max(0.0, _coyote_timer - delta)

	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	else:
		_jump_buffer_timer = max(0.0, _jump_buffer_timer - delta)

	# 4) --- Horizontal velocity target + acceleration ---
	var current_h := Vector3(velocity.x, 0, velocity.z)
	var target_h := wish_dir * move_speed

	var used_accel := accel if is_on_floor() else air_accel

	# Move current horizontal velocity toward target smoothly
	current_h = current_h.move_toward(target_h, used_accel * delta)

	# 5) --- Friction when no input (only on ground) ---
	if is_on_floor() and wish_dir == Vector3.ZERO:
		current_h = current_h.move_toward(Vector3.ZERO, friction * delta)

	velocity.x = current_h.x
	velocity.z = current_h.z

	# 6) --- Gravity ---
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		# keep grounded stable (prevents tiny bounces on slopes)
		if velocity.y < 0:
			velocity.y = -1.0

	# 7) --- Jump execution (buffer + coyote) ---
	if _jump_buffer_timer > 0 and _coyote_timer > 0:
		_jump_buffer_timer = 0
		_coyote_timer = 0
		# Physics: v = sqrt(2*g*h)
		velocity.y = sqrt(2.0 * gravity * jump_height)

	# 8) --- Move ---
	move_and_slide()
